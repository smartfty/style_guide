# == Schema Information
#
# Table name: issues
#
#  id             :integer          not null, primary key
#  date           :date
#  number         :string
#  plan           :text
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string
#
# Indexes
#
#  index_issues_on_publication_id  (publication_id)
#  index_issues_on_slug            (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (publication_id => publications.id)
#

require 'zip/zip'

class Issue < ApplicationRecord
  belongs_to :publication
  has_many  :page_plans
  has_many  :pages, -> { order(page_number: :asc) }
  has_one :spread
  has_many  :images
  accepts_nested_attributes_for :images
  has_many :ad_images
  accepts_nested_attributes_for :ad_images

  before_create :read_issue_plan
  after_create :setup
  validates_presence_of :date
  validates_uniqueness_of :date
  
  include IssueStoryMakeable

  def publication_path
    publication.path
  end

  def path
    publication_path + "/issue/#{date}"
  end

  def relative_path
    "#{publication_id}/issue/#{date}"
  end

  def default_issue_plan_path
    "#{Rails.root}/public/#{publication_id}/default_issue_plan.rb"
  end

  def default_issue_path
    "#{Rails.root}/public/#{publication_id}/default_issue_plan"
  end

  def set_color_page
    pages.each do |page|
      puts page.page_number
      if page.page_number == 22 || page.page_number == 23
        page.color_page = false
      else
        page.color_page = true
      end
      page.save
    end
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    system "mkdir -p #{issue_images_path}" unless File.directory?(issue_images_path)
    system "mkdir -p #{issue_ads_path}" unless File.directory?(issue_ads_path)
    # make_default_issue_plan
    # make_pages
  end

  def section_path
    "#{Rails.root}/public/#{publication_id}/section"
  end

  def newsml_path
    "#{Rails.root}/public/1/newsml"
  end

  def newsml_issue_path
    "#{Rails.root}/public/1/#{id}/newsml"
  end

  def eval_issue_plan
    eval(plan)
  end

  def issue_images_path
    path + '/images'
  end

  def issue_ads_path
    path + '/ads'
  end

  def issue_ad_list_path
    path + '/ads/ad_list.yml'
  end

  def issue_info_for_cms
    {
      'id' => id,
      'date' => date.to_s,
      'plan' => plan
    }
  end

  def current_working_articles_hash
    # code
  end

  def request_cms_new_issue
    puts __method__
    # cms_address = 'http://localhost:3001'
    # puts "#{cms_address}/#{id}"
    # RestClient.post( "#{cms_address}/api/v1/cms_new_issue/#{id}", {'payload' => issue_info_for_cms})
  end

  def news_cms_host
    'http://localhost:3001'
  end

  def news_cms_head
    "#{news_cms_host}/update_issue_plan"
  end

  def make_default_issue_plan
    # page_array = [page_number, profile]
    section_names_array = eval(publication.section_names)
    eval_issue_plan.each_with_index do |page_array, i|
      page_hash = {}
      page_hash[:issue_id] = id
      page_hash[:section_name]  = section_names_array[i]
      page_hash[:page_number]   = page_array[0]
      page_hash[:profile]       = page_array[1]
      p = PagePlan.where(page_hash).first_or_create!
    end
  end

  def update_plan
    make_pages
    # parse_images
    # parse_ad_images
    # parse_graphics
  end



  def make_spread
    puts 'in make_spread'
    Spread.create!(issue_id: id)
  end

  def make_pages
    page_plans.each_with_index do |page_plan, _i|
      if page_plan.page
        if page_plan.need_update?
          page_plan.page.change_template(page_plan.selected_template_id)
          page_plan.dirty = false
          page_plan.save
        end
        next
      else
        # create new page
        page_plan.page = Page.create!(issue_id: id, page_plan_id: page_plan.id, template_id: page_plan.selected_template_id)
        page_plan.dirty = false
        page_plan.save
      end
    end
  end


  def page_plan_with_ad
    list = []
    page_plans.each do |pp|
      list << pp if pp.ad_type
    end
    list
  end

  def ad_list
    list = []
    pages.each do |page|
      list << page.ad_info if page.ad_info
    end
    return false unless list.empty?
    list.to_yaml
  end

  def save_ad_info
    system("mkdir -p #{issue_ads_path}") unless File.directory?(issue_ads_path)
    File.open(issue_ad_list_path, 'w') { |f| f.write.ad_list } if ad_list
  end

  def parse_images
    Dir.glob("#{issue_images_path}/*{.jpg,.pdf}").each do |image|
      puts "+++++ image:#{image}"
      h = {}
      issue_image_basename  = File.basename(image)
      profile_array         = issue_image_basename.split('_')
      puts "profile_array:#{profile_array}"
      next if profile_array.length < 2
      puts "profile_array.length:#{profile_array.length}"
      # h[:image_path]        = image
      h[:page_number]       = profile_array[0].to_i
      h[:story_number]      = profile_array[1].to_i
      h[:column]            = 2
      h[:column]            = profile_array[2].to_i if profile_array.length > 3
      h[:landscape]         = true
      h[:caption_title]     = '사진설먕 제목'
      h[:caption]           = '사진설먕운 여기에 사진설명은 여기에 사진설명은 여기에 사진설명'
      h[:position]          = 3 # top_right 상단_우측
      # TODO read image file and determin orientaion from it.
      h[:used_in_layout]    = false
      h[:landscape]         = profile_array[3] if profile_array.length > 4
      h[:row] = if h[:landscape]
                  h[:column]
                else
                  h[:column] + 1
                end
      h[:extra_height_in_lines] = h[:row] * publication.lines_per_grid
      h[:issue_id] = id
      # h[:column]            = profile_array[2] if  profile_array.length > 3
      page = Page.where(issue_id: self, page_number: h[:page_number]).first
      puts "h[:issue_id]:#{h[:issue_id]}"
      puts "h[:page_number]:#{h[:page_number]}"
      unless page
        puts "Page: #{h[:page_number]} doesn't exist!!!!"
        next
      end
      working_article = WorkingArticle.where(page_id: page.id, order: h[:story_number]).first
      if working_article
        h[:working_article_id] = working_article.id
        puts "h:#{h}"
        Image.where(h).first_or_create
      # TODO: create symbolic link
      else
        puts "article at page:#{h[:page_number]} story_number: #{h[:story_number]} not found!!!}"
      end
    end
  end

  def parse_ad_images
    Dir.glob("#{issue_ads_path}/*{.jpg,.pdf}").each do |ad|
      h = {}
      h[:image_path]        = ad
      h[:issue_id]          = self
      AdImage.where(h).first_or_create
    end
  end

  def parse_graphics
    puts __method__
  end

  def ad_list
    list = []
    pages.each(&:ad_images)
  end

  def save_issue_plan_ad
    pages.each(&:save_issue_plan_ad)
  end

  def copy_sample_ad
    pages.each(&:copy_sample_ad)
  end

  def reset_issue_plan
    self.plan = File.open(default_issue_plan_path, 'r', &:read)
    save
    make_default_issue_plan
  end

  def xml_path
    path + '/newsml'
  end

  def xml_zip_path
    year          = date.year
    month         = date.month.to_s.rjust(2, '0')
    day           = date.day.to_s.rjust(2, '0')
    issue_date    = "#{year}#{month}#{day}"
    xml_path + "/#{issue_date}_story_xml.zip"
  end

  def preview_xml_path
    path + '/page_preview'
  end

  def preview_xml_zip_path
    year          = date.year
    month         = date.month.to_s.rjust(2, '0')
    day           = date.day.to_s.rjust(2, '0')
    issue_date    = "#{year}#{month}#{day}"
    preview_xml_path + "/#{issue_date}_page_preview.zip"
  end

  def mobile_preview_xml_path
    path + '/mobile_page_preview'
  end

  def mobile_preview_xml_zip_path
    year = date.year
    month         = date.month.to_s.rjust(2, '0')
    day           = date.day.to_s.rjust(2, '0')
    issue_date    = "#{year}#{month}#{day}"
    mobile_preview_xml_path + "/#{issue_date}_mobile_preview_xml.zip"
  end

  def make_story_xml_zip
    # Path where your pdfs are situated (‘my_pdf’ is folder with pdfs)
    folder = xml_path
    # input_filenames = Dir.glob("#{xml_path}/*.xml")
    input_filenames = Dir.glob("#{xml_path}/*.{xml,jpg}")
    zipfile_name = xml_zip_path
    system("rm #{xml_zip_path}") if File.exist?(xml_zip_path)
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        base_name = File.basename(filename)
        # Two arguments:
        # – The name of the file as it will appear in the archive
        # – The original file, including the path to find it
        zipfile.add(base_name, File.join(folder, base_name))
      end
      # zipfile.get_output_stream(“success”) { |os| os.write “All done successfully” }
    end
    # send_file(File.join("#{Rails.root}/public/", ‘myfirstzipfile.zip’), :type => ‘application/zip’, :filename => "#{xml_zip_name}")
    # Remove content from ‘my_pdfs’ folder if you want
    # FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/my_pdfs/*"))
  end

  def make_preview_xml_zip
    # Path where your pdfs are situated (‘my_pdf’ is folder with pdfs)
    folder = preview_xml_path
    input_filenames = Dir.glob("#{preview_xml_path}/*.{xml,jpg,pdf}")
    zipfile_name = preview_xml_zip_path
    system("rm #{preview_xml_zip_path}") if File.exist?(preview_xml_zip_path)
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        base_name = File.basename(filename)
        # Two arguments:
        # – The name of the file as it will appear in the archive
        # – The original file, including the path to find it
        zipfile.add(base_name, File.join(folder, base_name))
      end
      # zipfile.get_output_stream(“success”) { |os| os.write “All done successfully” }
    end
    # send_file(File.join("#{Rails.root}/public/", ‘myfirstzipfile.zip’), :type => ‘application/zip’, :filename => "#{xml_zip_name}")
    # Remove content from ‘my_pdfs’ folder if you want
    # FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/my_pdfs/*"))
  end

  class ZipFileGenerator
    # Initialize with the directory to zip and the location of the output archive.
    def initialize(input_dir, output_file)
      @input_dir = input_dir
      @output_file = output_file
    end

    def write
      entries = Dir.entries(@input_dir) - %w[. ..]

      ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |zipfile|
        write_entries entries, '', zipfile
      end
    end

    private

    # A helper method to make the recursion work.
    def write_entries(entries, path, zipfile)
      entries.each do |e|
        zipfile_path = path == '' ? e : File.join(path, e)
        disk_file_path = File.join(@input_dir, zipfile_path)
        puts "Deflating #{disk_file_path}"

        if File.directory? disk_file_path
          recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
        else
          put_into_archive(disk_file_path, zipfile, zipfile_path)
        end
      end
    end

    def recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
      zipfile.mkdir zipfile_path
      subdir = Dir.entries(disk_file_path) - %w[. ..]
      write_entries subdir, zipfile_path, zipfile
    end

    def put_into_archive(disk_file_path, zipfile, zipfile_path)
      zipfile.get_output_stream(zipfile_path) do |f|
        f.write(File.open(disk_file_path, 'rb').read)
      end
    end
end

  # def make_mobile_preview_xml_zip
  # folder = mobile_preview_xml_path
  # input_filenames = Dir.glob("#{mobile_preview_xml_path}/**.*")
  # zipfile_name = mobile_preview_xml_zip_path
  # system("rm #{mobile_preview_xml_zip_path}") if File.exist?(mobile_preview_xml_zip_path)
  # Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
  #   input_filenames.each do |filename|
  #     base_name = File.basename(filename)
  #     zipfile.add(base_name,  File.join(folder, base_name))
  #   end
  # end

  # Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
  #   Dir[File.join(folder, '*')].each do |file|
  #     zipfile.add(file.sub(folder, ''), file)
  #   end
  # end
  # end

  def full_page_ad
    pages.select{|p| p.section_name == "전면광고"}
  end

  def save_story_xml
    pages[0..0].each(&:ƒ)
    full_page_ad.each(&:save_story_xml)
    pages[21..22].each(&:save_story_xml)
    # make_story_xml_zip
  end

  def save_preview_xml
    pages[0..0].each(&:save_preview_xml)
    full_page_ad.each(&:save_preview_xml)
    pages[21..22].each(&:save_preview_xml)
    # make_preview_xml_zip
  end

  def mobile_page_preview_path
    "#{Rails.root}/public/1/issue/#{date}/mobile_page_preview"
  end

  def partial_xml_path
    "#{Rails.root}/public/1/issue/#{date}/partial_xml"
  end

    def save_mobile_preview_xml
    # full page ad
    s = ''
    u = ''
    # page 1 only for now!!
    pages[0..0].each do |page|
      s += page.all_container
      u += page.updateinfo
      page.save_mobile_preview_xml
      # all_container_xml_page = page.container_xml_page
    end
    full_page_ad.each do |page|
      s += page.all_container
      u += page.updateinfo
      page.save_mobile_preview_xml
      # all_container_xml_page = page.container_xml_page
    end
    # page 22 and 23 only for now!!
    pages[21..22].each do |page|
      s += page.all_container
      u += page.updateinfo
      page.save_mobile_preview_xml
      # all_container_xml_page = page.container_xml_page
    end
    system("mkdir -p #{partial_xml_path}") unless File.exist?(partial_xml_path)
    File.open(partial_xml_path + '/partial_Container.xml', 'w') { |f| f.write s }
    File.open(partial_xml_path + '/partial_updateinfo.xml', 'w') { |f| f.write u }
    mobile_xml_send
    # make_mobile_preview_xml_zip
    # directory_to_zip = mobile_preview_xml_path
    # output_file = mobile_preview_xml_zip_path
    # zf = ZipFileGenerator.new(directory_to_zip, output_file)
    # zf.write()
  end

  def copy_to_xml_ftp
    save_story_xml
    save_preview_xml
    xml_send
    true
  end

  # def xml_send_code
  #   jeho = issue.number
  #   yymd = issue.date.strftime("%y%m%d")
  #    "#{jeho}-#{yymd}#{pg}.pdf"
  # end

  def xml_send
    year          = date.year
    month         = date.month.to_s.rjust(2, '0')
    day           = date.day.to_s.rjust(2, '0')
    issue_date    = "#{year}#{month}#{day}"
    news_xml      = "#{issue_date}_news_xml"
    preview_xml   = "#{issue_date}_preview_xml"

    puts 'sending it to News & Preview Xml.zip'
    ip        = '211.115.91.231'
    id        = 'naeil'
    pw        = 'sodlftlsans1!'
    entries = Dir.glob("#{xml_path}/**/*").sort
    Net::FTP.open(ip, id, pw) do |ftp|
      ftp.mkdir news_xml
      entries.each do |name|
        base_name = File.basename(name)
        if File.directory? base_name
          # ftp.mkdir issue_date + "/#{base_name}"
          ftp.mkdir base_name
        else
          File.open(name) { |file| ftp.putbinaryfile(file, news_xml + "/#{base_name}") }
        end
      end
    end
    entries = Dir.glob("#{preview_xml_path}/**/*").sort
    Net::FTP.open(ip, id, pw) do |ftp|
      ftp.mkdir preview_xml
      entries.each do |name|
        base_name = File.basename(name)
        if File.directory? base_name
          # ftp.mkdir issue_date + "/#{base_name}"
          ftp.mkdir base_name
        else
          File.open(name) { |file| ftp.putbinaryfile(file, preview_xml + "/#{base_name}") }
        end
      end
    end
  end

    def merge_container_xml
    ip = '211.115.91.68'
    id        = 'jimeun'
    pw        = 'sodlfwlaus2018!@#$'

    year          = date.year
    month         = date.month.to_s.rjust(2, '0')
    day           = date.day.to_s.rjust(2, '0')
    issue_date    = "#{year}#{month}#{day}"

    ftp_folder              = "#{year}/#{month}/#{day}/"
    partial_folder          = partial_xml_path

    Net::FTP.open(ip, id, pw) do |ftp|
      ftp.chdir(ftp_folder)
      ftp.getbinaryfile('updateinfo.xml', "#{partial_xml_path}/updateinfo.xml")
      ftp.getbinaryfile('Container.xml', "#{partial_xml_path}/Container.xml")

      # ++++++++ Container
      # container_base_path     = partial_folder + '/Container.xml'
      # container_partial_path  = partial_folder + '/partial_Container.xml'
      # if File.exist?(container_base_path) && File.exist?(container_partial_path)
      #   base_content          = File.open(container_base_path, 'r', &:read)
      #   after_count_change    = base_content.sub(/<PageList Count="22">/, '<PageList Count="24">')
      #   partial_content       = File.open(container_partial_path, 'r', &:read)
      #   page_24_and_afer      = /<Page ID="100124">.*<\/ContainerML>/m
      #   result = after_count_change.match(page_24_and_afer)
      #   final = result.pre_match + partial_content + result.to_s
      #   File.open(container_base_path, 'w') { |f| f.write final }
      #   FileUtils.rm(container_partial_path)
      # else
      #   puts 'No Container.xml or No partial_Container.xml !!!!'
      # end

      # ++++++++ updateinfo
      # updateinfo_base_path          = partial_folder + '/updateinfo.xml'
      # updateinfo_partial_path       = partial_folder + '/partial_updateinfo.xml'
      # if File.exist?(updateinfo_base_path) && File.exist?(updateinfo_partial_path)
      #   updateinfo_content          = File.open(updateinfo_base_path, 'r', &:read)
      #   after_info_change           = updateinfo_content.sub(/<UpdateCount>22<\/UpdateCount>/, '<UpdateCount>24</UpdateCount>')
      #   updateinfo_partial_content  = File.open(updateinfo_partial_path, 'r', &:read)
      #   info_page_24_and_afer       = /<PageKey>\d{8}_\d{6}24<\/PageKey>.*<\/UpdateInfo>/m
      #   info_result                 = after_info_change.match(info_page_24_and_afer)
      #   info_final                  = info_result.pre_match + updateinfo_partial_content + info_result.to_s
      #   File.open(updateinfo_base_path, 'w') { |f| f.write info_final }
      #   FileUtils.rm(updateinfo_partial_path)
      # else
      #   puts 'No updateinfo.xml or No partial_updateinfo.xml !!!!'
      # end
      # ftp.rename("#{ftp_folder}/.xml", "updateinfo.xml.old")
      # ftp.rename("#{ftp_folder}/Contaiupdateinfoner.xml", "Container.xml.old")
     
      # 합성만 하고 업로드 안하게 임시 주석처리 2018.10.01
      # ftp.putbinaryfile("#{partial_xml_path}/updateinfo.xml", 'updateinfo.xml')
      # ftp.putbinaryfile("#{partial_xml_path}/Container.xml", 'Container.xml')
    end
  end

  # check target ftp folder every 5 min for 2 hrs (5min x 24 = 2hrs)
  def wait_for_xml_upload
    year          = date.year
    month         = date.month.to_s.rjust(2, '0')
    day           = date.day.to_s.rjust(2, '0')
    issue_date    = "#{year}#{month}#{day}"
    ip        = '211.115.91.68'
    id        = 'jimeun'
    pw        = 'sodlfwlaus2018!@#$'
    ftp_folder = "#{year}/#{month}/#{day}"
    found = false
    24.times do
      Net::FTP.open(ip, id, pw) do |ftp|
        ftp.chdir(ftp_folder)
        files_in_folder = ftp.list
        files_in_folder.each do |file|
          found = true if file.include?('Container.xml')
          break if found
        end
      end
      return true if found
      sleep 3000 # 5 min
    end
    found
  end

  
  def mobile_xml_send
    year          = date.year
    month         = date.month.to_s.rjust(2, '0')
    day           = date.day.to_s.rjust(2, '0')
    issue_date    = "#{year}#{month}#{day}"
    puts 'sending it tp Mobile Preview Xml.zip'
    ip        = '211.115.91.68'
    id        = 'jimeun'
    pw        = 'sodlfwlaus2018!@#$'
    # 다른곳에 먼저 테스트
    # ip        = '211.115.91.231'
    # id        = 'naeil'
    # pw        = 'sodlftlsans1!'
    ftp_folder = "#{year}/#{month}/#{day}"
    entries = Dir.glob("#{mobile_preview_xml_path}/**/*").sort
    Net::FTP.open(ip, id, pw) do |ftp|
      ftp.chdir(ftp_folder)
      # ftp.chdir("#{year}/#{month}/#{day}/")
      entries.each do |name|
        base_name = File.basename(name)
        dir_name  = File.dirname(name)
        dir_base_name = File.basename(dir_name)
        if File.directory? name
          ftp.mkdir base_name.to_s
        else
          puts "-------------- #{ftp_folder}/#{dir_base_name}/#{base_name}"
          File.open(name) { |file| ftp.putbinaryfile(file, "#{dir_base_name}/#{base_name}") }
        end
      end
    end
    result = wait_for_xml_upload
    if result
      puts 'xml file upload found and proceeding merge'
      merge_container_xml
    else
      puts 'xml file upload not found!!!'
    end
  end

  def prepare
    read_issue_plan
  end

  def spread_left_page
    puts "pages.count:#{pages.count}"
    return if pages.count == 0
    half = pages.count/2
    puts "half:#{half}"
    pages[half - 1]
  end

  def spread_right_page
    return if pages.count == 0
    half = pages.count/2
    pages[half]
  end

  private

  def read_issue_plan
    __method__
    if File.exist?(default_issue_plan_path)
      self.plan = File.open(default_issue_plan_path, 'r', &:read)
      return true
    else
      puts "#{default_issue_plan_path} does not exist!!!"
      return false
    end
  end
end
