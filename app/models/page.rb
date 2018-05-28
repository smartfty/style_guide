# == Schema Information
#
# Table name: pages
#
#  id           :integer          not null, primary key
#  page_number  :integer
#  section_name :string
#  column       :integer
#  row          :integer
#  ad_type      :string
#  story_count  :integer
#  color_page   :boolean
#  profile      :string
#  issue_id     :integer
#  page_plan_id :integer
#  template_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  clone_name   :string
#
# Indexes
#
#  index_pages_on_issue_id      (issue_id)
#  index_pages_on_page_plan_id  (page_plan_id)
#
require 'net/ftp'

class Page < ApplicationRecord
  belongs_to :issue
  belongs_to :page_plan
  has_many :working_articles
  has_many :ad_boxes
  has_one :page_heading
  before_create :copy_attributes_from_template
  after_create :setup
  scope :clone_page, -> {where("clone_name!=?", nil)}
  attr_reader :time_stamp

  DAYS_IN_KOREAN = %w{일요일 월요일 화요일 수요일 목요일 금요일 토요일 }
  DAYS_IN_ENGLISH = Date::DAYNAMES

  def path
    if clone_name == nil
      "#{Rails.root}/public/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}"
    else
      "#{Rails.root}/public/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}-#{clone_name}"
    end
  end

  def date
    issue.date.to_s
  end

  def relative_path
    "/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}"
  end

  def url
    "/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}"
  end


  def latest_pdf
    f = Dir.glob("#{path}/section*.pdf").last
    File.basename(f) if f
  end

  def latest_pdf_basename
    if @time_stamp
      f = Dir.glob("#{path}/section#{@time_stamp}.pdf")
    else
      f = Dir.glob("#{path}/section*.pdf").last
      File.basename(f) if f
    end
  end

  def latest_pdf_path
    Dir.glob("#{path}/#{latest_pdf_basename}").first
  end

  def pdf_image_path
    # if @time_stamp
    "/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}/#{latest_pdf_basename}"
    # else
    #   "/#{publication.id}/issue/#{page.issue.date.to_s}/#{page.page_number}/#{order}/story.pdf"
    # end
  end

  def pdf_path
    "#{Rails.root}/public/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}/section.pdf"
  end

  def jpg_image_path
    "/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}/section.jpg"
  end

  def jpg_path
    "#{Rails.root}/public/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}/section.jpg"
  end

  def to_hash
    p_hash = attributes
    p_hash.delete('created_at')    # delete created_at
    p_hash.delete('updated_at')     # delete updated_at
    p_hash.delete('id')             # delete id
    p_hash
  end

  def siblings(article)
    grid_x          = article.grid_x
    grid_right_edge = article.grid_x + article.column
    grid_bottom     = article.grid_y + article.row
    working_articles.select do |wa|
      wa.grid_y == grid_bottom && wa.grid_x >= grid_x && wa != article
    end
  end

  def bottom_article?(article)
    article_bottom_grid     = article.grid_y + article.row
    article_x_grid          = article.grid_x
    article_y_grid          = article.grid_y
    return true if article_bottom_grid == row
    ad_box = ad_boxes.first
    return false if ad_box.nil?
    ad_box_x_max_grid       = ad_box.grid_x + ad_box.column
    if ad_box.grid_y == article_bottom_grid && ad_box.grid_x <= article_x_grid && article_x_grid <= ad_box_x_max_grid
      return true
    end
    false
  end

  def clone
    h = to_hash

    h[:clone_name] = 'b'
    unless b = Page.where(h).first
      Page.create!(h)
      return
    end
    h[:clone_name] = 'c'
    unless c = Page.where(h).first
      Page.create!(h)
      return
    end
    h[:clone_name] = 'd'
    unless c = Page.where(h).first
      Page.create!(h)
      return
    end
  end

  def publication
    issue.publication
  end

  def page_heading_path
    path + "/heading"
  end

  def page_heading_url
    url + "/heading"
  end

  def page_headig_layout_path
    page_heading_path + "/layout.rb"
  end

  def doc_width
    publication.width
  end

  def page_width
    publication.page_width
  end

  def doc_height
    publication.height
  end

  def doc_left_margin
    publication.left_margin
  end

  def doc_top_margin
    publication.top_margin
  end

  def page_height
    publication.page_height
  end

  # def page_heading
  #   publication.page_heading(page_number)
  # end
  def page_heading_width
    publication.page_heading_width
  end

  def page_heading_height
    if page_number == 1
      publication.front_page_heading_height_in_pt
    else
      publication.inner_page_heading_height_in_pt
    end
  end

  def issue_week_day_in_korean
    date = issue.date
    DAYS_IN_KOREAN[date.wday]
  end

  def year
    date = issue.date
    date.year
  end

  def month
    date = issue.date
    date.month
  end

  def day
    date = issue.date
    date.day
  end

  def korean_date_string
    date = issue.date
    if page_number == 1
      "#{date.year}년 #{date.month}월 #{date.day}일 #{issue_week_day_in_korean} (#{issue.number}호)"
    else
      "#{date.year}년 #{date.month}월 #{date.day}일 #{issue_week_day_in_korean}"
    end
  end

  def self.update_page_headings
    Page.all.each do |page|
      PageHeading.generate_pdf(page)
    end
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    copy_section_template
  end

  def sample_ad_folder
    "#{Rails.root}/public/#{publication.id}/ad"
  end

  def issue_ads_folder
    "#{Rails.root}/public/#{publication.id}/issue/#{issue.date.to_s}/ads"
  end

  def ad_image_string
    ad = ad_images.first
    if ad
      return ad_images.first.ad_image_string
    end
    ""
  end

  def save_issue_plan_ad
    if ad_type && ad_type != ""
      issue_ad_string = "#{page_number}_#{ad_type}"
      system "cd #{issue_ads_folder} && touch #{issue_ad_string}"
    end
  end

  def select_sample_ad
    Dir.glob("#{sample_ad_folder}/#{page_columns}#{ad_type}/*{.jpg,.pdf}").sample
  end

  def copy_sample_ad
    if ad_type && ad_type != ""
      sample = select_sample_ad
      basename = File.basename(sample)
      ad_name  = "#{page_number}_#{basename}"
      system "cp #{sample} #{issue_ads_folder}/ad_name"
    end
  end

  def section_template_folder
    "#{Rails.root}/public/#{publication.id}/section/#{page_number}/#{profile}/#{template_id}"
  end

  def update_working_articles
    # delete unused working_articles
    section = Section.find(template_id)
    if section.articles.length == 0
      # if new page is full page ad, delete working articles from paeg
      working_articles.each do |wa|
        wa.inactive = true
      end
    else
      section.articles.each_with_index do |article, i|
        current = {page_id: self.id, order:i+1, kind:'기사'}
        if wa = WorkingArticle.where(current).first
          wa.change_article(article)
        else
          current[:article_id] = article.id
          WorkingArticle.create(current)
        end
      end
      # mark unused as inactive
      working_articles.each_with_index do |working_article, i|
        working_article.extend_line(0)
        if i >= section.articles.length
          working_article.inactive = true
        else
          working_article.inactive = false
        end
        working_article.save
      end
    end
    # create PageHeading for this page
    heading_atts                  = {}
    heading_atts[:page_number]    = section.page_number
    heading_atts[:section_name]    = section.page_number
    heading_atts[:page_id]        = self.id
    heading_atts[:date]           = issue.date
    result                        = PageHeading.where(heading_atts).first_or_create
  end

  def update_ad_boxes
    section = Section.find(template_id)
    section.ad_box_templates.each_with_index do |ad_box_template, i|
      current = {page_id: self.id}
      #TODO
      if ad = AdBox.where(current).first
      else
        current[:grid_x] = ad_box_template.grid_x
        current[:grid_y] = ad_box_template.grid_y
        current[:column] = ad_box_template.column
        current[:row] = ad_box_template.row
        current[:order] = i
        AdBox.create(current)
      end
    end
    # mark unused as inactive
    ad_boxes.each_with_index do |ad_box, i|
      if i >= section.ad_box_templates.length
        ad_box.inactive = true
      else
        ad_box.inactive = false
      end
      ad_box.save
    end
  end

  def story_backup_folder
    path + "/story_backup"
  end

  def backup_stories(story_number)
    #code
  end

  def copy_ad_template
    #code
  end

  def config_path
    path + "/config.yml"
  end

  def copy_config_file
    source = section_template_folder + "/config.yml"
    config_hash = YAML::load_file(source)
    config_hash['date'] = issue.date.to_s
    target = path + "/config.yml"
    File.open(target, 'w'){|f| f.write(config_hash.to_yaml)}
  end

  def copy_section_pdf
    source = section_template_folder + "/section.pdf"
    target = path + "/section.pdf"
    system "cp #{source} #{target}"
    jpg_source = section_template_folder + "/section.jpg"
    jpg_target = path + "/section.jpg"
    system "cp #{jpg_source} #{jpg_target}"
  end

  def copy_heading
    FileUtils.mkdir_p(page_heading_path) unless File.exist?(page_heading_path)
    source = issue.publication.heading_path + "/#{page_number}"
    target = page_heading_path
    layout_erb_path     = page_heading_path + "/layout.erb"
    # unless File.exist? layout_erb_path
    system "cp -R #{source}/ #{target}/"
    # end
    layout_erb_content  = File.open(layout_erb_path, 'r'){|f| f.read}
    erb                 = ERB.new(layout_erb_content)
    @date               = korean_date_string
    @section_name       = section_name
    @page_number        = page_number
    layout_content      = erb.result(binding)
    layout_rb_path      = page_heading_path + "/layout.rb"
    File.open(layout_rb_path, 'w'){|f| f.write layout_content}
    system "cd #{page_heading_path} && /Applications/rjob.app/Contents/MacOS/rjob ."
  end

  def copy_section_template
    puts __method__
    source = Dir.glob("#{section_template_folder}/*").first
    old_article_count = working_articles.length
    section           = Section.find(template_id)
    new_aricle_count  = section.story_count
    if source
      copy_config_file
      new_aricle_count.times do |i|
        source = section_template_folder + "/#{i + 1}"
        article_foloder = path + "/#{i + 1}"
        # if artile folder is empty, copy the whole article template folder
        unless File.exist?(article_foloder)
          FileUtils.mkdir_p article_foloder
          system("cp -r #{source}/ #{article_foloder}/")
        # if there are current article, copy layout.rb from article template
        else
          layout_template = source + "/layout.rb"
          system("cp  #{layout_template} #{article_foloder}/")
        end
        puts "i:#{i}"
      end

      # backup or restore story from previous template change
      # if there are some left over article from previous layout, delete them.
      if old_article_count > new_aricle_count
        FileUtils.mkdir_p story_backup_folder unless File.exist?(story_backup_folder)
        left_over_count = old_article_count - new_aricle_count
        puts "left_over_count:#{left_over_count}"
        left_over_count.times do |i|
          story_number      = new_aricle_count + i + 1
          left_over_foloder = path + "/#{story_number}"
          left_over_stroy   = left_over_foloder + "/story.md"
          backup_name       = story_backup_folder + "/#{story_number}_story.md"
          system "rm -r #{left_over_foloder}"
        end
      elsif old_article_count < new_aricle_count
        increased_count = new_aricle_count - old_article_count
        puts "increased_count:#{increased_count}"
        increased_count.times do |i|
          story_number      = old_article_count + i + 1
          increased_foloder = path + "/#{story_number}"
          increased_story   = increased_foloder + "/story.md"
          backup_file_name  = story_backup_folder + "/#{story_number}_story.md"
          system "cp  #{backup_file_name} #{increased_story}" if File.exist?(backup_file_name)
        end
      end
      #TODO How about ad?
      copy_ad_template
    else
      puts "No template in #{section_template_folder}"
    end
    update_working_articles
    update_ad_boxes
    #TODO
    copy_heading
    regenerate_pdf
    # system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section ."
  end

  def change_template(new_template_id)
    puts "++++++++ new_template_id:#{new_template_id}"
    new_section                 = Section.find(new_template_id)
    section_hash                = new_section.attributes
    section_hash                = Hash[section_hash.map{ |k, v| [k.to_sym, v] }]
    section_hash[:template_id]  = new_template_id
    section_hash.delete(:id)
    section_hash.delete(:layout)
    section_hash.delete(:order)
    section_hash.delete(:is_front_page)
    section_hash.delete(:publication_id)
    section_hash.delete(:created_at)
    section_hash.delete(:updated_at)
    section_hash.delete(:draw_divider)
    update(section_hash)
    # update ad_box
    # remove current ad_boxz unless new template has same size ad
    if ad_boxes.count > 0 && (new_section.ad_box_templates.count == 0 || new_section.ad_box_templates.first.ad_type != ad_boxes.first.ad_type)
      ad_boxes.each do |ad_box|
        ad_box.page_id = nil
        ad_box.save
      end
    elsif new_section.ad_box_templates.count == 1
      new_ad_template = new_section.ad_box_templates.first
      ad_box_hash                = new_ad_template.attributes
      ad_box_hash                = Hash[ad_box_hash.map{ |k, v| [k.to_sym, v] }]
      ad_box_hash.delete(:id)
      ad_box_hash.delete(:section_id)
      ad_box_hash.delete(:created_at)
      ad_box_hash.delete(:updated_at)
      ad_box_hash[:page_id] = id
      AdBox.create(ad_box_hash)
    end
    copy_config_file
    #TODO change heading section_name to full page ad if new template is full page ad
    generate_heading_pdf
    update_working_articles
    update_ad_boxes
    regenerate_pdf
  end

  def save_as_default
    default_issue_plan_path = issue.default_issue_plan_path
    issue_hash = eval(File.open(default_issue_plan_path, 'r'){|f| f.read})
    issue_hash[page_number - 1] << template_id
    File.open(default_issue_plan_path, 'w'){|f| f.write issue_hash.to_s}
  end


  def heading_height_in_pt
    if page_number == 1
      publication.front_page_heading_height_in_pt
    else
      publication.inner_page_heading_height_in_pt
    end
  end

  def page_width
    publication.page_width
  end

  def page_height
    publication.page_height
  end

  def generate_heading_pdf
    page_heading.generate_pdf
  end

  def stamp_time
    t = Time.now
    h = t.hour
    @time_stamp = "#{t.day.to_s.rjust(2,'0')}#{t.hour.to_s.rjust(2,'0')}#{t.min.to_s.rjust(2,'0')}#{t.sec.to_s.rjust(2,'0')}"
  end

  def delete_latest_files
    pdf_file_to_delete = latest_pdf_path
    jpf_file_to_delte = pdf_file_to_delete.sub(/pdf$/, "jpg")
    puts "pdf_file_to_delete:#{pdf_file_to_delete}"
    puts "File.exist?(pdf_file_to_delete):#{File.exist?(pdf_file_to_delete)}"
    system("rm #{pdf_file_to_delete}")
    system("rm #{jpf_file_to_delte}")
  end

  def delete_old_files
    old_pdf_files = Dir.glob("#{path}/section*.pdf")
    old_jpg_files = Dir.glob("#{path}/section*.jpg")
    old_pdf_files += old_jpg_files
    old_pdf_files.each do |old|
      system("rm #{old}")
    end
  end

  def generate_pdf_with_time_stamp
    delete_old_files
    stamp_time
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section . -time_stamp=#{@time_stamp}"
  end

  def generate_pdf
    puts "generate_pdf for page"
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section ."
    # copy_outputs_to_site
  end

  def regenerate_pdf
    puts __method__
    puts "working_articles.length:#{working_articles.length}"
    working_articles.each do |working_article|
      puts "calling working_article.generate_pdf"
      working_article.generate_pdf
    end
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section ."
    # copy_outputs_to_site
  end

  def site_path
    File.expand_path("~/Sites/naeil/#{issue.date.to_s}/#{page_number}")
  end

  def copy_outputs_to_site
    FileUtils.mkdir_p site_path unless File.exist?(site_path)
    system "cp #{pdf_path} #{site_path}/"
    system "cp #{jpg_path} #{site_path}/"
  end

  def eval_layout
    eval(layout)
  end

  # other SectionTemplate choices for current page
  def other_choices
    Section.where(page_number: page_number).all
  end

  def page_heading_jpg_path
    page_heading_url + "/output.jpg"
  end

  def page_heading_pdf_path
    page_heading_url + "/output.pdf"
  end

  def page_svg
    "<image xlink:href='#{pdf_image_path}' x='0' y='0' width='#{doc_width}' height='#{doc_height}' />\n"
    #code
  end

  def box_svg
    box_element_svg = page_svg
    box_element_svg += "<g transform='translate(#{doc_left_margin},#{doc_top_margin})' >\n"
    # box_element_svg += page_svg
    box_element_svg += page_heading.box_svg if page_number == 1
    working_articles.each do |article|
      next if article.inactive
      box_element_svg += article.box_svg
    end
    ad_boxes.each do |ad_box|
      box_element_svg += ad_box.box_svg
    end
    box_element_svg += '</g>'
    box_element_svg
  end

  def to_svg
    svg=<<~EOF
    <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 #{doc_width} #{doc_height}' >
      <rect fill='white' x='0' y='0' width='#{doc_width}' height='#{doc_height}' />
      #{box_svg}
    </svg>
    EOF
  end

  def page_svg_with_jpg
    "<image xlink:href='#{jpg_image_path}' x='0' y='0' width='#{doc_width}' height='#{doc_height}' />\n"
  end

  def box_svg_with_jpg
    box_element_svg = page_svg_with_jpg
    box_element_svg += "<g transform='translate(#{doc_left_margin},#{doc_top_margin})' >\n"
    # box_element_svg += page_svg
    box_element_svg += page_heading.box_svg if page_number == 1
    working_articles.each do |article|
      next if article.inactive
      box_element_svg += article.box_svg
    end
    ad_boxes.each do |ad_box|
      box_element_svg += ad_box.box_svg
    end
    box_element_svg += '</g>'
    box_element_svg
  end

  def to_svg_with_jpg
    svg=<<~EOF
    <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 #{doc_width} #{doc_height}' >
      <rect fill='white' x='0' y='0' width='#{doc_width}' height='#{doc_height}' />
      #{box_svg_with_jpg}
    </svg>
    EOF
  end

  def proof_path
    path + "/proof"
  end

  def generate_proof_pdf
    FileUtils.mkdir_p(proof_path) unless File.exist?(proof_path)
    r_page_number = page_number.to_s.rjust(2,"0")
    date          = issue.date.day.to_s.rjust(2,"0")
    month         = issue.date.month.to_s.rjust(2,"0")
    year          = issue.date.year.to_s
    proof_files   = Dir.glob("#{proof_path}/#{r_page_number}011001*")
    if proof_files.length == 0
      target_file   = "proof/#{r_page_number}011001-#{date}#{month}#{year}000.pdf"
    else
      curernt_index = proof_files.length
      target_file = "proof/#{r_page_number}011001-#{date}#{month}#{year}000_#{curernt_index}.pdf"
    end
    puts "target_file:#{target_file}"
    system("cd #{path} && cp section.pdf #{target_file}")
    target_file
  end

  def copy_to_proof_reading_ftp
    puts "copying page pdf to proof reading ftp "
    ip  = '211.115.91.75'
    id  = 'naeil'
    pw  = 'sodlftlsans1!'
    last_generate_file = generate_proof_pdf
    # upload files
    latest_proof_file = File.new(path + "/#{last_generate_file}")
    Net::FTP.open(ip, id, pw) do |ftp|
      ftp.putbinaryfile(latest_proof_file, "#{File.basename(latest_proof_file)}")
    end
    true
  end

  def copy_to_printer_ftp
    dong_a
    jung_ang
    true
  end

  def dong_a
    puts "sending it to Dong-A"
    # 동아일보 인쇄용
    ip        = '210.115.142.181'
    id        = 'naeil'
    pw        = 'cts@'
    # upload files
    printer_file = path + "/section.pdf"
    jung_ang_code = "zn05282210001.pdf"

    Net::FTP.open(ip, id, pw) do |ftp|
      ftp.putbinaryfile(printer_file, "/mono/#{jung_ang_code}")
    end
  end

  def jung_ang_code
    date = issue.date
    m = date.month.to_s.rjust(2,"0")
    d = date.day.to_s.rjust(2,"0")
    pg = page_number.to_s.rjust(2,"0")
     "zn#{m}#{d}#{pg}10001.pdf"
  end

  def jung_ang
    puts "sending it to Jung-Ang"
    ip        = '112.216.44.45:2121'
    id        = 'naeil'
    pw        = 'sodlf@2018'
    # upload files
    printer_file = path + "/section.pdf"
    ftp = Net::FTP.new  # don't pass hostname or it will try open on default port
    ftp.connect('112.216.44.45', '2121')  # here you can pass a non-standard port number
    ftp.login('naeil', 'sodlf@2018')
    # ftp.passive = true  # optional, if PASV mode is required
    # Net::FTP.open(ip, id, pw) do |ftp|
    ftp.putbinaryfile(printer_file, "/Naeil/#{jung_ang_code}")
    # end
  end

  def dropbox_path
    File.expand_path("~/dropbox")
  end

  def dropbox_page_path
    dropbox_path + "/#{date}_#{page_number}.pdf"
  end

  def dropbox_exist?
    File.exist?(dropbox_path)
  end

  def copy_to_drop_box
    unless dropbox_exist?
      return "드롭박스가 설치되지 않았습니다."
    else
      system("cp #{pdf_path} #{dropbox_page_path}")
      return true
    end
  end

  def save_story_xml
    working_articles.each do |article|
      article.save_story_xml
    end
  end

  def section_pages
    issue.pages.select{|p| p.section_name == section_name}
  end


  private

  def copy_attributes_from_template
    section = Section.find(template_id)
    self.profile      = section.profile
    self.page_number  = section.page_number
    self.section_name  = section.section_name
    self.column       = section.column
    self.row          = section.row
    self.ad_type      = section.ad_type
    self.story_count  = section.story_count
    true
  end

end
