# == Schema Information
#
# Table name: pages
#
#  id                           :integer          not null, primary key
#  page_number                  :integer
#  section_name                 :string
#  column                       :integer
#  row                          :integer
#  ad_type                      :string
#  story_count                  :integer
#  color_page                   :boolean
#  profile                      :string
#  issue_id                     :integer
#  page_plan_id                 :integer
#  template_id                  :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  clone_name                   :string
#  slug                         :string
#  layout                       :text
#  publication_id               :integer
#  path                         :string
#  date                         :date
#  grid_width                   :float
#  grid_height                  :float
#  lines_per_grid               :float
#  width                        :float
#  height                       :float
#  left_margin                  :float
#  top_margin                   :float
#  right_margin                 :float
#  bottom_margin                :float
#  gutter                       :float
#  article_line_thickness       :float
#  page_heading_margin_in_lines :integer
#
# Indexes
#
#  index_pages_on_issue_id      (issue_id)
#  index_pages_on_page_plan_id  (page_plan_id)
#  index_pages_on_slug          (slug) UNIQUE
#

require 'erb'
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
  include PageSplitable
  include PageSavePDF
  # extend FriendlyId
  # friendly_id :friendly_string, :use => [:slugged]

  DAYS_IN_KOREAN = %w{일요일 월요일 화요일 수요일 목요일 금요일 토요일 }
  DAYS_IN_ENGLISH = Date::DAYNAMES

  def friendly_string
    "#{date.to_s}_#{page_number}"
  end

  def is_front_page?
    page_number == 1
  end

  def relative_path
    # "/#{publication_id}/issue/#{date.to_s}/#{page_number}"
    #Todo
    "/#{publication_id}/issue/#{date.to_s}/#{page_number}"

  end

  def url
    "/#{publication_id}/issue/#{date.to_s}/#{page_number}"
  end


  def latest_pdf
    f = Dir.glob("#{path}/section*.pdf").sort.last
    File.basename(f) if f
  end

  def latest_pdf_basename
    if @time_stamp
      f = Dir.glob("#{path}/section#{@time_stamp}.pdf")
    else
      f = Dir.glob("#{path}/section*.pdf").sort.last
      File.basename(f) if f
    end
  end

  def latest_jpg_basename
    if @time_stamp
      f = Dir.glob("#{path}/section#{@time_stamp}.jpg")
    else
      f = Dir.glob("#{path}/section*.jpg").sort.last
      File.basename(f) if f
    end
  end

  def pdf_image_path
    # if @time_stamp
    "/#{publication_id}/issue/#{date.to_s}/#{page_number}/#{latest_pdf_basename}"
  end

  def pdf_path
    "#{Rails.root}/public/#{publication_id}/issue/#{date.to_s}/#{page_number}/section.pdf"
  end

  def jpg_image_path
    "/#{publication_id}/issue/#{date.to_s}/#{page_number}/#{latest_jpg_basename}"
  end

  def jpg_path
    "#{Rails.root}/public/#{publication_id}/issue/#{date.to_s}/#{page_number}/section.jpg"
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
    siblings_array = working_articles.select do |wa|
      wa_right_edge = wa.grid_x + wa.column
      wa.grid_y == grid_bottom && wa.grid_x >= grid_x && wa_right_edge <= grid_right_edge  && wa != article
    end
    # siblings_array += image_boxes.select do |image_box|
    #   image_box.grid_y == grid_bottom && wa.grid_x >= grid_x && wa != article
    # end
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
    # width + left_margin + right_margin
  end

  def page_width
    publication.page_width
    # width
  end

  def doc_height
    publication.height
    # height + top_margin + bottom_margin
  end

  def doc_left_margin
    publication.left_margin
    # left_margin
  end

  def doc_top_margin
    publication.top_margin
    # top_margin
  end

  def page_height
    publication.page_height

    # height
  end

  def page_heading_width
    # width
    publication.page_heading_width
  end

  def issue_week_day_in_korean
    DAYS_IN_KOREAN[date.wday]
  end

  def year
    date.year
  end

  def month
    date.month
  end

  def day
    date.day
  end

  def korean_date_string
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
    section   = Section.find(template_id)
    copy_section_template(section)
    create_heading(section)
    create_working_articles(section)
    create_ad_boxes(section)
    save_config_file unless File.exist?(config_path)
    generate_pdf unless File.exist?(pdf_path)
  end

  def sample_ad_folder
    "#{Rails.root}/public/#{publication_id}/ad"
  end

  def issue_ads_folder
    "#{Rails.root}/public/#{publication_id}/issue/#{date.to_s}/ads"
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
    Dir.glob("#{sample_ad_folder}/#{column}#{ad_type}/*{.jpg,.pdf}").sample
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
    "#{Rails.root}/public/#{publication_id}/section/#{page_number}/#{profile}/#{template_id}"
  end

  def change_working_articles(section)
    if section.articles.length == 0
      # if new page is full page ad, delete working articles from page
      working_articles.each do |wa|
        # wa.inactive = true
        wa.destroy
      end
    else
      sorted_articles = section.articles.sort_by {|article| article.order}
      sorted_articles.each_with_index do |article, i|
        current = {page_id: self.id, order: i + 1}
        if wa = WorkingArticle.where(current).first
          wa.change_article(article)
          wa.generate_pdf_with_time_stamp
        else
          #create new working_articles
          att = article.attributes
          att.delete('id')
          att.delete('created_at')
          att.delete('updated_at')
          att.delete('personal_image')
          att.delete('section_id')
          att.delete('personal_image')
          att['page_id']              = self.id
          att['article_id']           = article.id
          # current[:extended_line_count] = article.extended_line_count || 0
          # current[:pushed_line_count]   = article.pushed_line_count || 0
          w = WorkingArticle.create(att)
          w.generate_pdf_with_time_stamp
        end
      end
      # mark unused as inactive
      sorted_working_articles = working_articles.sort_by {|article| article.order}
      sorted_working_articles.each_with_index do |working_article, i|
        # working_article.extended_line_count = 0
        # working_article.grid_width = grid_width
        # working_article.grid_height = grid_height
        # if working_article.order > section.articles.length
        #   working_article.inactive = true
        # else
        #   working_article.inactive = false
        # end
        # working_article.save
        if working_article.order > section.articles.length
          # update story and image before destroying
          working_article.destroy
        end
      end
    end
    # working_articles.each do |working_article|
    #   working_article.generate_pdf_with_time_stamp
    # end

    # # create PageHeading for this page
    # heading_atts                  = {}
    # heading_atts[:page_number]    = section.page_number
    # heading_atts[:section_name]   = section.section_name
    # heading_atts[:page_id]        = self.id
    # heading_atts[:date]           = date
    # result                        = PageHeading.where(heading_atts).first_or_create
  end

  def change_ad_boxes(section)
    # assuming only one ad per page,
    # TODO handle case when there are multiple ads in a page
    # section.ad_box_templates.each_with_index do |ad_box_template, i|
    ad_box_template = section.ad_box_templates.first
    if ad_box_template
      current = {page_id: self.id, ad_type: self.ad_type}
      if ad = AdBox.where(current).first
        puts  "same type found, do nothing"
      else
        current            = {}
        current['page_id'] = id
        current['ad_type'] = ad_box_template.ad_type
        current['grid_x']  = ad_box_template.grid_x
        current['grid_y']  = ad_box_template.grid_y
        current['column']  = ad_box_template.column
        current['row']     = ad_box_template.row
        current['order']   = 1

        if ad_boxes.length > 0
          puts "different type of ad exists: #{ad_box_template.ad_type}, change it to new ad type :#{current[:ad_type]}"
          currnet_ad_box = ad_boxes.first
          currnet_ad_box.update(current)
          currnet_ad_box.save
          currnet_ad_box.generate_pdf_with_time_stamp
        else
          a = AdBox.create(current)
          a.generate_pdf
        end
      end
    end

    # mark unused as inactive
    # ad_boxes.each_with_index do |ad_box, i|
    #   if i >= section.ad_box_templates.length
    #     ad_box.inactive = true
    #   else
    #     ad_box.inactive = false
    #   end
    #   ad_box.save
    # end
  end

  def story_backup_folder
    path + "/story_backup"
  end

  def backup_stories(story_number)
    #code
  end

  def config_path
    path + "/config.yml"
  end

  def config_hash
    h = {}
    h['section_name']                   = section_name
    h['page_heading_margin_in_lines']   = page_heading_margin_in_lines
    h['ad_type']                        = ad_type || "no_ad"
    h['is_front_page']                  = is_front_page?
    h['profile']                        = profile
    h['section_id']                     = id
    h['page_columns']                   = column
    h['grid_size']                      = [grid_width, grid_height]
    h['lines_per_grid']                 = lines_per_grid
    h['width']                          = width
    h['height']                         = height
    h['left_margin']                    = left_margin
    h['top_margin']                     = top_margin
    h['right_margin']                   = right_margin
    h['bottom_margin']                  = bottom_margin
    h['gutter']                         = gutter
    h['story_frames']                   = eval(layout)
    h['article_line_thickness']         = article_line_thickness
    h
  end

  def config_yml_path
    path + "/config.yml"
  end

  def save_config_file
    system "mkdir -p #{path}" unless File.directory?(path)
    yaml = config_hash.to_yaml
    File.open(config_yml_path, 'w'){|f| f.write yaml}
  end

  def copy_config_file
    source = section_template_folder + "/config.yml"
    config_hash = YAML::load_file(source)
    config_hash['date'] = date.to_s
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

  def put_space_between_chars(string)
    s = ""
    i = 0
    length = string.length
    string.each_char do |ch|
      if i >= length - 1
        s += ch
      elsif ch == " "
        s += ch
      else
        s += ch + " "
      end
      i += 1
    end
    s
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
    # @section_name       = section_name
    @section_name       = put_space_between_chars(section_name)
    @page_number        = page_number
    layout_content      = erb.result(binding)
    layout_rb_path      = page_heading_path + "/layout.rb"
    File.open(layout_rb_path, 'w'){|f| f.write layout_content}
    system "cd #{page_heading_path} && /Applications/newsman.app/Contents/MacOS/newsman rjob ."
  end

  def copy_section_template(section)
    puts __method__
    source = Dir.glob("#{section_template_folder}/*").first
    old_article_count = working_articles.length
    new_aricle_count  = section.story_count
    if source
      copy_config_file
      copy_section_pdf
      new_aricle_count.times do |i|
        source = section_template_folder + "/#{i + 1}"
        article_folder = path + "/#{i + 1}"
        # if artile folder is empty, copy the whole article template folder
        unless File.exist?(article_folder)
          FileUtils.mkdir_p article_folder
          system("cp -r #{source}/ #{article_folder}/")
        # if there are current article, copy layout.rb from article template
        else
          layout_template = source + "/layout.rb"
          system("cp  #{layout_template} #{article_folder}/")
        end
      end
      copy_ad_folder
      copy_heading
    else
      puts "no section"
    end

  end

  def copy_ad_folder
    ad_folder = section_template_folder + "/ad"
    system("cp  -r #{ad_folder} #{path}") if File.exist? ad_folder
  end

  def create_working_articles(section)
    sorted_articles = section.articles.sort_by {|article| article.order}
    sorted_articles.each_with_index do |article, i|
      current = {page_id: self.id, order:i+1}
      current[:article_id]          = article.id
      current[:extended_line_count] = article.extended_line_count || 0
      current[:pushed_line_count]   = article.pushed_line_count || 0
      w = WorkingArticle.where(current).first_or_create
    end
  end

  def create_heading(section)
    heading_atts                  = {}
    heading_atts[:page_number]    = page_number
    heading_atts[:section_name]   = section_name
    heading_atts[:page_id]        = self.id
    heading_atts[:date]           = date
    result                        = PageHeading.where(heading_atts).first_or_create
  end

  def create_ad_boxes(section)
    section.ad_box_templates.each_with_index do |ad_box_template, i|
      current = {page_id: self.id}
      current[:grid_x] = ad_box_template.grid_x
      current[:grid_y] = ad_box_template.grid_y
      current[:column] = ad_box_template.column
      current[:row] = ad_box_template.row
      current[:order] = i
      AdBox.create(current)
    end
  end

  def change_template(new_template_id)
    new_section                  = Section.find(new_template_id)
    new_page_hash                = new_section.attributes
    new_page_hash                = Hash[new_page_hash.map{ |k, v| [k.to_sym, v] }]
    new_page_hash[:page_number]  = page_number
    new_page_hash[:section_name] = page_plan.section_name
    new_page_hash[:template_id]  = new_template_id
    new_page_hash.delete(:id)
    new_page_hash.delete(:path)
    new_page_hash.delete(:order)
    new_page_hash.delete(:is_front_page)
    new_page_hash.delete(:created_at)
    new_page_hash.delete(:updated_at)
    new_page_hash.delete(:draw_divider)
    update(new_page_hash)
    save_config_file
    generate_heading_pdf
    change_working_articles(new_section)
    change_ad_boxes(new_section)
    generate_pdf_with_time_stamp
  end

  def change_heading
    section  = Section.find(template_id)
    FileUtils.mkdir_p(page_heading_path) unless File.exist?(page_heading_path)
    source = section.page_heading_path
    target = page_heading_path
    layout_erb_path     = page_heading_path + "/layout.erb"
    # unless File.exist? layout_erb_path
    system "cp -R #{source}/ #{target}/"
    # end
    layout_erb_content  = File.open(layout_erb_path, 'r'){|f| f.read}
    erb                 = ERB.new(layout_erb_content)
    @date               = korean_date_string
    # @section_name       = section_name
    @section_name       = put_space_between_chars(section_name)
    @page_number        = page_number
    layout_content      = erb.result(binding)
    layout_rb_path      = page_heading_path + "/layout.rb"
    File.open(layout_rb_path, 'w'){|f| f.write layout_content}
    system "cd #{page_heading_path} && /Applications/newsman.app/Contents/MacOS/newsman rjob ."
  end

  def save_as_default
    default_issue_plan_path = issue.default_issue_plan_path
    issue_hash = eval(File.open(default_issue_plan_path, 'r'){|f| f.read})
    issue_hash[page_number - 1] << template_id
    File.open(default_issue_plan_path, 'w'){|f| f.write issue_hash.to_s}
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
    pdf_file_to_delete = Dir.glob("#{path}/section*.pdf")
    jpg_file_to_delte = pdf_file_to_delete.map{|f| f.sub(/pdf$/, "jpg")}
    pdf_file_to_delete.each do |old|
      system("rm #{old}")
    end
    jpg_file_to_delte.each do |old|
      system("rm #{old}")
    end
  end

  def generate_pdf_with_time_stamp
    delete_latest_files
    stamp_time
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section . -time_stamp=#{@time_stamp}"
  end

  def generate_pdf
    puts "generate_pdf for page"
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section ."
    # copy_outputs_to_site
  end

  def regenerate_pdf
    generate_heading_pdf
    working_articles.each do |working_article|
      working_article.generate_pdf
    end
    ad_boxes.each do |ad_box|
      ad_box.generate_pdf
    end
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section ."
    # copy_outputs_to_site
  end

  def site_path
    File.expand_path("~/Sites/naeil/#{date.to_s}/#{page_number}")
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
    if ad_box = ad_boxes.first
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

  def printer_file
    path + "/section.pdf"
  end

  def copy_to_proof_reading_ftp
    require 'net/ftp'
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

  def printer_folder
    path + "/printer"
  end

  def latest_printer_file
    Dir.glob("#{printer_folder}/*.pdf").sort.last
  end

  def printer_file_version
    File.basename(latest_printer_file).split("_")[1].to_i
  end

  def backup_printer_file
    target_file = printer_folder + "/section_0.pdf"
    FileUtils.mkdir_p(printer_folder) unless File.exist?(printer_folder)
    current_files = Dir.glob("#{printer_folder}/*.pdf")
    if current_files.length > 0
      target_file = printer_folder + "/section_#{current_files.length}.pdf"
    end
    FileUtils.cp(printer_file, target_file)
  end

  def copy_to_printer_ftp
    backup_printer_file
    news_pdf
    ex_pdf
    jung_ang
    dong_a
    true
  end

  def send_to_expdf_ftp
    news_pdf
    ex_pdf
  end

  def dong_a_code
    date = issue.date
    m = date.month.to_s.rjust(2,"0")
    d = date.day.to_s.rjust(2,"0")
    pg = page_number.to_s.rjust(2,"0")
    if printer_file_version == 0
      if color_page
        "NA#{m}#{d}#{pg}NC01.pdf"
      else
        "NA#{m}#{d}#{pg}NB01.pdf"
      end
    else
      if color_page
        "NA#{m}#{d}#{pg}NC0#{printer_file_version + 1}.pdf"
      else
        "NA#{m}#{d}#{pg}NB0#{printer_file_version + 1}.pdf"
      end
    end
  end

  def dong_a
    puts "sending it to Dong-A"
    ip        = '210.115.142.181'
    id        = 'naeil'
    pw        = 'cts@'
    Net::FTP.open(ip, id, pw) do |ftp|
      if color_page
        ftp.putbinaryfile(printer_file, "/color/#{dong_a_code}")
      else
        ftp.putbinaryfile(printer_file, "/mono/#{dong_a_code}")
      end
    end
    # ip        = '211.115.91.231'
    # id        = 'naeil'
    # pw        = 'sodlftlsans1!'
    # Net::FTP.open(ip, id, pw) do |ftp|
    #   ftp.putbinaryfile(printer_file, "#{dong_a_code}")
    # end
  end

  def jung_ang_code
    date = issue.date
    m = date.month.to_s.rjust(2,"0")
    d = date.day.to_s.rjust(2,"0")
    pg = page_number.to_s.rjust(2,"0")
    if printer_file_version == 0
      "zn#{m}#{d}#{pg}10001.pdf"
     else
      "zn#{m}#{d}#{pg}10001_#{printer_file_version}.pdf"
     end
   end

  def jung_ang
    puts "sending it to Jung-Ang"
    # ip        = '112.216.44.45:2121'
    # id        = 'naeil'
    # pw        = 'sodlf@2018'
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


    # 2018-7-23
    # puts "sending it to Jung-Ang"
    # ip        = '112.216.44.45:2121'
    # id        = 'naeil'
    # pw        = 'sodlf@2018'
    # Net::FTP.open(ip, id, pw) do |ftp|
    #   ftp.putbinaryfile(printer_file, "/Naeil/#{jung_ang_code}")
    # end
    # ip        = '211.115.91.231'
    # id        = 'naeil'
    # pw        = 'sodlftlsans1!'
    # Net::FTP.open(ip, id, pw) do |ftp|
    #   ftp.putbinaryfile(printer_file, "#{jung_ang_code}")
    # end


  def news_pdf_code
    yyyymd = issue.date.strftime("%Y%m%d")
    pg = page_number.to_s.rjust(2,"0")
    "#{yyyymd}-#{pg}.pdf"
  end

  def news_pdf
    puts "sending it to News PDF"
    ip        = '211.115.91.231'
    id        = 'comp'
    pw        = '*4141'
    yyyymd = issue.date.strftime("%Y%m%d")
    Net::FTP.open(ip, id, pw) do |ftp|
      ftp.putbinaryfile(printer_file, "/NewsPDF/#{yyyymd}/#{news_pdf_code}")
    end
  end

  def ex_pdf_code
    jeho = issue.number
    yymd = issue.date.strftime("%y%m%d")
    pg = page_number.to_s.rjust(2,"0")
    "#{jeho}-#{yymd}#{pg}.pdf"
  end

  def ex_pdf
    puts "sending it to External PDF"
    ip        = '211.115.91.231'
    id        = 'comp'
    pw        = '*4141'
    yyyymd = issue.date.strftime("%Y%m%d")
    Net::FTP.open(ip, id, pw) do |ftp|
      ftp.putbinaryfile(printer_file, "/외부전송PDF/#{ex_pdf_code}")
    end
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


  def save_preview_xml
   date = issue.date
   @day = date.day.to_s.rjust(2,"0")
   @month = date.month.to_s.rjust(2,"0")
   @year = date.year % 100
   @date = "#{@year}#{@month}#{@day}"
   @page_number = page_number.to_s.rjust(2,"0")
   @filename = "#{issue.number}-#{@date}#{@page_number}"
   scale = 1.6

   header =<<~EOF
   <?xml version="1.0" encoding="UTF-8"?>
   <PDFScrap version="1.0">
     <scraps zoom="120">\n
   EOF
   template =<<~EOF
   <Scrap title="<%= @filename %>_1_<%= @order %>.jpg" page="1" type="rectangle">
     <vertices><%= (@x_position*scale).round(0) %>;<%= (@y_position*scale).round(0) %>;<%=((@x_position + w.width)*scale).round(0) %>;<%= ((@y_position + w.height)*scale).round(0) %></vertices>
   </Scrap>
   EOF
   @issue_number = issue.number
   @page_number = page_number

   article_map_path = "#{Rails.root}/public/1/issue/#{issue.date.to_s}/page_preview"
   article_map = header
   working_articles.sort_by{|x| x.order}.each do |w|
     @order = w.order - 1
     @x_position = publication.left_margin + w.x
     @y_position = publication.top_margin + w.y
     erb = ERB.new(template)
     article_map += erb.result(binding) + "\n"
     article_map_jpg_image_path = article_map_path + "/#{@filename}_1_#{@order}.jpg"
     # binding.pry if w.page_number==22
     # system("cp #{w.jpg_path} #{article_map_jpg_image_path}")
     FileUtils.mkdir_p(article_map_path) unless File.exist?(article_map_path)
     FileUtils.cp(w.jpg_path, article_map_jpg_image_path)

   end
   ad_boxes.each do |w|
     @order = working_articles.length
     @x_position = publication.left_margin + w.x
     @y_position = publication.top_margin + w.y
     erb = ERB.new(template)
     article_map += erb.result(binding) + "\n"
     article_map_jpg_image_path = article_map_path + "/#{@filename}_1_#{@order}.jpg"
     FileUtils.mkdir_p(article_map_path) unless File.exist?(article_map_path)
     FileUtils.cp(w.jpg_path, article_map_jpg_image_path)
     # system("cp #{w.jpg_path} #{article_map_jpg_image_path}")
   end
   article_map += "</scraps><pdf filename='#{@filename}.PDF'/></PDFScrap>"
   system("mkdir -p #{article_map_path}") unless File.exist?(article_map_path)
   File.open(article_map_path + "/#{@filename}.xml", 'w'){|f| f.write article_map}
   system("cp #{pdf_path} #{article_map_path}/#{@filename}.pdf")
  end

  def page_info
    page_number.to_s.rjust(2,"0")
  end

  def mobile_page_preview_path
    "#{Rails.root}/public/1/issue/#{issue.date.to_s}/mobile_page_preview/1001#{page_info}"
  end

  def xml_section_name
    if page_number == 22 || page_number == 23
      "논설#{page_number - 21}"
    else
      section_name
    end
  end

  def all_container
    year  = issue.date.year
    month = issue.date.month.to_s.rjust(2, "0")
    day   = issue.date.day.to_s.rjust(2, "0")
    @page_key         = "#{year}#{month}#{day}_011001#{page_info}"

    container_xml_page_id=<<EOF
    <Page ID="1001<%= page_info %>">
      <PageKey><%= @page_key %></PageKey>
      <PageTitle>#{xml_section_name}</PageTitle>
      <PaperSize>A2</PaperSize>
EOF
    page_container_xml = ""
    container_xml = ""
    container = ""
    # container_xml_page = ""
    erb=ERB.new(container_xml_page_id)
    container_xml += erb.result(binding)
    working_articles.sort_by{|x| x.order}.each do |w|
      page_container_xml += w.xml_group_key_template
    end
    ad_boxes.each do |w|
      page_container_xml += w.xml_group_key_template
    end
    # container += container_xml  + "\n" + page_container_xml
    container += container_xml
    container + page_container_xml + "    </Page>" + "\n"
  end

  def updateinfo
    year  = issue.date.year
    month = issue.date.month.to_s.rjust(2, "0")
    day   = issue.date.day.to_s.rjust(2, "0")
    @page_key         = "#{year}#{month}#{day}_011001#{page_info}"
    page_key=<<EOF
    <PageKey><%= @page_key %></PageKey>
EOF
    erb=ERB.new(page_key)
    erb.result(binding)
  end


  def save_mobile_preview_xml
    puts "++++++++++++ page_number:#{page_number}"
    default_time      = "00:00:00"
    year  = issue.date.year
    month = issue.date.month.to_s.rjust(2, "0")
    day   = issue.date.day.to_s.rjust(2, "0")
    # w_updated_at = working_articles.first.updated_at
    updated_date      = "#{year}-#{month}-#{day}"
    updated_time      = updated_at.strftime("%H:%M:%S")
    @date_id          = updated_date
    @day_info         = "#{year}년#{month}월#{day}일"
    @media_info       = publication.name
    date = issue.date
    @day = date.day.to_s.rjust(2,"0")
    @month = date.month.to_s.rjust(2,"0")
    @year = date.year
    @date = "#{@year}#{@month}#{@day}"
    @filename = "#{@date}_011001#{page_info}"
    @article_filename = "#{@date}.011001#{page_info}"
    @jeho_num         = issue.number
    @news_date        = "#{updated_date}T#{default_time}"
    @news_meun_2      = page_number.to_s.rjust(2,"0")
    @news_meun        = page_number
    @issue_title      = section_name
    @writre_and_time  = "#{updated_date}T#{updated_time}"
    @page_key         = "#{year}#{month}#{day}_011001#{page_info}"
    @article_count    = working_articles.length

    system("mkdir -p #{mobile_page_preview_path}") unless File.exist?(mobile_page_preview_path)
    system("cp #{jpg_path} #{mobile_page_preview_path}")
    resize_name = "#{@date}_011001#{page_info}"
    system "cd #{mobile_page_preview_path} && convert section.jpg -resize 2300x3191  #{resize_name}.jpg"
    system "cd #{mobile_page_preview_path} && convert section.jpg -resize 1856x2575  #{resize_name}c.jpg"
    system "cd #{mobile_page_preview_path} && convert section.jpg -resize 1150x1595  #{resize_name}b.jpg"
    system "cd #{mobile_page_preview_path} && convert section.jpg -resize 640x888  #{resize_name}a.jpg"
    system "cd #{mobile_page_preview_path} && convert section.jpg -resize 160x222  #{resize_name}s.jpg"
    system "rm #{mobile_page_preview_path}/section.jpg"

    mobile_layout_ml =<<EOF
<?xml version="1.0" encoding="UTF-8"?>
  <MobileLayoutML>
    <PageInfo>
      <NewsPlus Program="NewsLayout" Version="12.0"/>
      <NewsID>1</NewsID>
      <NewsName>내일신문</NewsName>
      <JeHoNum><%= @jeho_num %></JeHoNum>
      <NewsDate><%= @news_date %></NewsDate>
      <NewsPan>10</NewsPan>
      <NewsSectionID SectionName="A" DisplayName="A">1</NewsSectionID>
      <NewsMeun><%= @news_meun %></NewsMeun>
      <Page>A<%= @news_meun %></Page>
      <Title><%= @issue_title  %></Title>
      <WriteAndTime><%= @writre_and_time %></WriteAndTime>
      <LogOnUser/>
      <PageID>1001<%= @news_meun_2 %></PageID>
      <PageKey><%= @page_key %></PageKey>
      <ArticleCount><%= @article_count %></ArticleCount>
      <PaperSize>A2</PaperSize>
    </PageInfo>
EOF
# binding.pry
     size_array = %w[CoordinateListReal CoordinateListOrg CoordinateListA CoordinateListB CoordinateListC]
     # scale_array = [4.128, 1.148, 2.064, 3.332, 0.286]
     # scale_array = [19.790, 2.023, 0.558, 1, 1.627]
     scale_array = [20.423, 2.087, 0.575, 1.032, 1.679]
     # scale_array = [20.5, 2.1, 0.6, 1.1, 1.7]


    map_component=<<EOF
      <<%= name %>>
        <List><%= (@x1 * scale).round(0) %>,<%= (@y1 * scale).round(0) %>,<%= (@x2 * scale).round(0) %>,<%= (@y2 * scale).round(0) %></List>
        <Polygon><%= (@x1 * scale).round(0) %>,<%= (@y1 * scale).round(0) %>;<%= (@x2 * scale).round(0) %>,<%= (@y1 * scale).round(0) %>;<%= (@x2 * scale).round(0) %>,<%= (@y2 * scale).round(0) %>;<%= (@x2 * scale).round(0) %>,<%= (@y2 * scale).round(0) %>;<%= (@x1 * scale).round(0) %>,<%= (@y2 * scale).round(0) %>;</Polygon>
      </<%= name %>>
EOF

      mobile_layout = ""
      erb=ERB.new(mobile_layout_ml)
      mobile_layout += erb.result(binding)

      working_articles.sort_by{|x| x.order}.each do |w|
        @order = (w.order).to_s.rjust(2,'0')
        @x1 = (publication.left_margin + w.x)
        @x2 = (@x1 + w.width)
        # if (page_number == 22 || page_number == 23) && (@order == 1 || @order == 2)
        if (page_number == 22 || page_number == 23) && (@order == 1 || @order == 2)
          puts "page_number:#{page_number}"
          puts "@order:#{@order}"
          @y1 = (publication.top_margin + w.y + 55.073)
          @y2 = (@y1 + w.height - 55.073 + w.extended_line_height)
          puts "@y2:#{@y2}"
          puts "w.extended_line_height:#{w.extended_line_height}"

        else
          puts "page_number:#{page_number}"
          puts "@order:#{@order}"
          @y1 = (publication.top_margin + w.y)
          @y2 = (@y1 + w.height)
        end
        # binding.pry
        scale_map=""
        size_array.each_with_index do |name, i|
          scale = scale_array[i]
          erb=ERB.new(map_component)
          scale_map += erb.result(binding)
        end
        # w.covert_euckr_not_suported_chars
        mobile_layout += "  <Article>" + "\n" + w.mobile_preview_xml_article_info
        mobile_layout += "    <MapComponent>" + "\n" + scale_map + "    </MapComponent>" + "\n"
        mobile_layout += w.mobile_preview_xml_three_component
        article_map_jpg_image_path = mobile_page_preview_path + "/#{@article_filename}0000#{@order}.jpg"
        system("cp #{w.jpg_path} #{article_map_jpg_image_path}")
    end

    ad_boxes.each do |w|
      @order = (working_articles.length + 1).to_s.rjust(2,'0')
      @x1 = (publication.left_margin + w.x)
      @x2 = (@x1 + w.width)
      @y1 = (publication.top_margin + w.y)
      @y2 = (@y1 + w.height)
      scale_map = ""
      size_array.each_with_index do |name, i|
        scale = scale_array[i]
        erb=ERB.new(map_component)
        scale_map += erb.result(binding)
      end
      # erb=ERB.new(mobile_layout_ml)
      # mobile_layout += erb.result(binding)
      mobile_layout += "  <Article>" + "\n" + w.mobile_preview_xml_article_info
      mobile_layout += "    <MapComponent>" + "\n" + scale_map + "    </MapComponent>" + "\n"
      mobile_layout += w.mobile_preview_xml_component

      # erb_map = ERB.new(map_component)
      # article_map += erb_map.result(binding)
      article_map_jpg_image_path = mobile_page_preview_path + "/#{@article_filename}0000#{@order}.jpg"
      system("cp #{w.jpg_path} #{article_map_jpg_image_path}")
    end


     # mobile_layout_ml += article_info
     mobile_layout += "\n" + " </MobileLayoutML>"
     working_articles.each do |article|
       article.save_mobile_xml_image
     end

    File.open(mobile_page_preview_path + "/#{@filename}.xml", 'w'){|f| f.write mobile_layout}
    system("cp #{pdf_path} #{mobile_page_preview_path}/#{@filename}.pdf")
    system("cp #{mobile_page_preview_path} #{mobile_page_preview_path}/#{@filename}.pdf")
  end

  # def container_xml_page
  #   # page_info        = page_number.to_s.rjust(2,"0")
  #
  # end

  def save_story_xml
    if section_name == "전면광고"
      ad = ad_boxes.first
      ad.order = 1
      ad.save
      ad.save_ad_xml
    else
      working_articles.each do |article|
        article.save_story_xml
      end
      ad_boxes.each do |ad|
        ad.order = working_articles.length + 1
        ad.save_ad_xml
      end
    end

  end

  def section_pages
    issue.pages.select{|p| p.section_name == section_name}
  end


  private

  def copy_attributes_from_template
    section         = Section.find(template_id)
    self.publication_id = issue.publication.id
    self.date         = issue.date
    self.profile      = section.profile
    # self.page_number  = section.page_number
    # self.section_name = section.section_name
    self.column       = section.column
    self.row          = section.row
    self.ad_type      = section.ad_type
    self.story_count  = section.story_count
    self.grid_width   = section.grid_width
    self.grid_height  = section.grid_height
    self.lines_per_grid = section.lines_per_grid
    self.width        = section.width
    self.height       = section.height
    self.left_margin  = section.left_margin
    self.top_margin   = section.top_margin
    self.right_margin = section.right_margin
    self.bottom_margin = section.bottom_margin
    self.gutter       = section.gutter
    self.article_line_thickness = section.article_line_thickness
    self.layout       = section.layout
    self.page_heading_margin_in_lines = section.page_heading_margin_in_lines
    if clone_name == nil
      self.path = "#{Rails.root}/public/#{self.publication_id}/issue/#{self.date.to_s}/#{page_number}"
    else
      self.path = "#{Rails.root}/public/#{self.publication_id}/issue/#{self.date.to_s}/#{page_number}-#{clone_name}"
    end
    true
  end

end
