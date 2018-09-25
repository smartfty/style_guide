# == Schema Information
#
# Table name: working_articles
#
#  id                           :integer          not null, primary key
#  grid_x                       :integer
#  grid_y                       :integer
#  column                       :integer
#  row                          :integer
#  order                        :integer
#  kind                         :string
#  profile                      :string
#  title                        :text
#  title_head                   :string
#  subtitle                     :text
#  subtitle_head                :string
#  body                         :text
#  reporter                     :string
#  email                        :string
#  personal_image               :string
#  image                        :string
#  quote                        :text
#  subject_head                 :string
#  on_left_edge                 :boolean
#  on_right_edge                :boolean
#  is_front_page                :boolean
#  top_story                    :boolean
#  top_position                 :boolean
#  inactive                     :boolean
#  extended_line_count          :integer
#  pushed_line_count            :integer
#  article_id                   :integer
#  page_id                      :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  quote_box_size               :integer
#  category_code                :integer
#  slug                         :string
#  publication_name             :string
#  path                         :string
#  date                         :date
#  page_number                  :integer
#  page_heading_margin_in_lines :integer
#  grid_width                   :float
#  grid_height                  :float
#  gutter                       :float
#
# Indexes
#
#  index_working_articles_on_article_id  (article_id)
#  index_working_articles_on_page_id     (page_id)
#  index_working_articles_on_slug        (slug) UNIQUE
#

class WorkingArticle < ApplicationRecord
  belongs_to :page
  belongs_to :article, optional: true
  has_many :images
  before_create :init_atts
  after_create :setup
  accepts_nested_attributes_for :images
  include ArticleSplitable
  extend FriendlyId
  friendly_id :make_frinedly_slug, :use => [:slugged]

  attr_reader :time_stamp

  def page_friendly_string
    page.friendly_string
  end

  def make_frinedly_slug
    "#{page_friendly_string}_#{order}"
  end

  def page_path
    page.path
  end

  def path
    page_path + "/#{order}"
  end

  def setup
    FileUtils.mkdir_p path unless File.exist?(path)
  end

  def images_path
    path + "/images"
  end

  def layout_path
    path + "/layout.rb"
  end

  def story_path
    path + "/story.md"
  end

  def pdf_path
    path + "/story.pdf"
  end

  def jpg_path
    path + "/story.jpg"
  end

  def old_pdf_path
    path + "/output.pdf"
  end

  def old_jpg_path
    path + "/output.jpg"
  end

  def change_ouput_to_story
    system "mv #{old_pdf_path} #{pdf_path}"
    system "mv #{old_jpg_path} #{jpg_path}"
  end

  def latest_pdf_basename
    # binding.pry
    f = Dir.glob("#{path}/story*.pdf").sort.last
    File.basename(f) if f
  end

  def latest_jpg_basename
    f = Dir.glob("#{path}/story*.jpg").sort.last
    File.basename(f) if f
  end


  def pdf_image_path
    "/#{publication.id}/issue/#{page.issue.date.to_s}/#{page.page_number}/#{order}/#{latest_pdf_basename}"
  end

  def page_number
    page.page_number
  end

  def jpg_image_path
    "/#{publication.id}/issue/#{page.issue.date.to_s}/#{page.page_number}/#{order}/#{latest_jpg_basename}"
  end

  def article_info_path
    path + "/article_info.yml"
  end

  def issue
    page.issue
  end

  def save_article
    save_layout
    save_story unless kind == '사진'
  end

  def update_pdf
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
  end

  def stamp_time
    t = Time.now
    h = t.hour
    @time_stamp = "#{t.day.to_s.rjust(2,'0')}#{t.hour.to_s.rjust(2,'0')}#{t.min.to_s.rjust(2,'0')}#{t.sec.to_s.rjust(2,'0')}"
  end

  def delete_old_files
    old_pdf_files = Dir.glob("#{path}/story*.pdf")
    old_jpg_files = Dir.glob("#{path}/story*.jpg")
    old_pdf_files += old_jpg_files
    old_pdf_files.each do |old|
      system("rm #{old}")
    end
  end

  def generate_pdf_with_time_stamp
    save_article
    delete_old_files
    stamp_time
    # session[:time_stamp] = @stamp_time
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article .  -custom=#{publication.name} -time_stamp=#{@time_stamp}"
  end

  def generate_pdf
    # @time_stamp =  true
    # binding.pry
    save_article
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article . -custom=#{publication.name}"
    # copy_outputs_to_site
  end

  def site_path
    page_site_path + "/#{order}"
  end

  def page_site_path
    page.site_path
  end

  def copy_outputs_to_site
    FileUtils.mkdir_p site_path unless File.exist?(site_path)
    system "cp #{pdf_path} #{site_path}/"
    system "cp #{jpg_path} #{site_path}/"
  end

  def siblings
    page.siblings(self)
  end

  def character_count
    return 0 unless body
    body.length
  end

  def add_extended_line_count_to_config_yml(line_count)
    puts __method__
    config_path = page.config_path
    config_hash = YAML::load_file(config_path)
    frame_array = config_hash['story_frames'][order - 1]
    if frame_array.last =~/^extend/
      frame_array[-1] = "extend_#{line_count}"
    else
      frame_array << "extend_#{line_count}"
    end
    File.open(config_path, 'w'){|f| f.write config_hash.to_yaml}
  end

  def remove_extended_line_count_from_config_yml
    config_path = page.config_path
    config_hash = YAML::load_file(config_path)
    frame_array = config_hash['story_frames'][order - 1]
    if frame_array.last =~/^extend/
      frame_array.pop
    elsif frame_array.last =~/^push/
      frame_array.pop
    end
    File.open(config_path, 'w'){|f| f.write config_hash.to_yaml}
  end

  def extended_line_height
    if extended_line_count.nil?
      return 0
    end
    extended_line_count * publication.body_line_height
  end

  def pushed_line_height
    if pushed_line_count.nil?
      return 0
    end
    pushed_line_count * publication.body_line_height
  end

  def set_extend_line(line_count)
    return if line_count == extended_line_count
    self.extended_line_count = line_count
    self.save
    siblings.each do |sybling|
      sybling.push_line(line_count)
    end
    generate_pdf_with_time_stamp

    if line_count == 0
      remove_extended_line_count_from_config_yml
    else
      add_extended_line_count_to_config_yml(line_count)
    end
    page.generate_pdf_with_time_stamp
  end

  def extend_line(line_count)
    return if line_count == 0
    if self.extended_line_count
      self.extended_line_count += line_count
    else
      self.extended_line_count = line_count
    end
    self.save
    siblings.each do |sybling|
      sybling.push_line(self.extended_line_count)
    end
    generate_pdf_with_time_stamp
    add_extended_line_count_to_config_yml(self.extended_line_count)

    if line_count == 0
      remove_extended_line_count_from_config_yml
    else
      add_extended_line_count_to_config_yml(self.extended_line_count)
    end
    page.generate_pdf_with_time_stamp
  end


  def add_pushed_line_count_to_config_yml(line_count)
    config_path = page.config_path
    config_hash = YAML::load_file(config_path)
    frame_array = config_hash['story_frames'][order - 1]
    if frame_array.last =~/^push/
      frame_array[-1] = "push_#{line_count}"
    else
      frame_array << "push_#{line_count}"
    end
    File.open(config_path, 'w'){|f| f.write config_hash.to_yaml}
  end

  def push_line(line_count)
    self.pushed_line_count = line_count
    self.save
    generate_pdf
    add_pushed_line_count_to_config_yml(self.pushed_line_count)
  end

  def change_story_with(new_story)
    h = new_story[:heading]
    self.subject_head      = h['subject_head'] = subject_head
    self.title             = h['title']
    self.subtitle          = h['subtitle']
    self.quote             = h['quote']
    self.reporter          = h['reporter']
    self.email             = h['email']
    self.body              = new_story[:body]
    self.save
    
  end

  def swap
    return unless siblings.length == 1
    sybling = siblings.first
    sybling_story = sybling.story_yml
    my_story = story_yml
    sybling.change_story_with(my_story)
    change_story_with(sybling_story)
    update_page_pdf
  end

  def show_quote_box?
    quote && quote != "" || quote_box_size && quote_box_size != "0"
  end

  def empty_lines_count
    h = article_info
    return nil unless h
    h[:empty_lines]
  end

  def quote_auto
    empty_lines = empty_lines_count
    return  0 unless empty_lines && empty_lines > 4
    if empty_lines > 8
      quote_line(3)
    elsif empty_lines >= 8
      quote_line(3)
    end
  end

  def quote_line(line_count)
    puts "line_count: #{line_count}"
    self.quote_box_size = line_count
    self.save
  end

  def update_page_pdf
    page_path = page.path
    system "cd #{page_path} && /Applications/newsman.app/Contents/MacOS/newsman section ."
  end

  def update_page_pdf_with_time_stamp
    page_path = page.generate_pdf_with_time_stamp
    system "cd #{page_path} && /Applications/newsman.app/Contents/MacOS/newsman section ."
  end

  def article_info
    if File.exist?(article_info_path)
      return @article_info_hash ||= YAML::load(File.open(article_info_path, 'r'){|f| f.read})
    else
      puts "#{article_info_path} does not exist!!!"
      return nil
    end
  end

  def filtered_title
    RubyPants.new(title).to_html
  end

  def story_metadata
    h = {}
    h['extended_line_count'] = extended_line_count if extended_line_count && extended_line_count > 0
    h['pushed_line_count'] = pushed_line_count if pushed_line_count && pushed_line_count > 0
    h['subject_head'] = subject_head
    h['title']      = RubyPants.new(title).to_html
    h['subtitle']   = RubyPants.new(subtitle).to_html unless (kind == '사설' || kind == '기고')
    h['quote']      = RubyPants.new(quote).to_html  if quote_box_size.to_i > 0
    h['reporter']   = reporter
    h['email']      = email
    h
  end

  def story_yml
    h = {}
    h[:heading] = story_metadata
    h[:body]    = body
    h
  end

  def story_md
    story_md =<<~EOF
    #{story_metadata.to_yaml}
    ---
    #{RubyPants.new(body).to_html}
    EOF
  end


  def publication
    page.issue.publication
  end

  def opinion_profile_pdf_path
    publication.path + "/opinion/#{reporter}.pdf"
  end

  def opinion_profile_jpg_path
    publication.path + "/opinion/#{reporter}.jpg"
  end


  # IMAGE_FIT_TYPE_ORIGINAL       = 0
  # IMAGE_FIT_TYPE_VERTICAL       = 1
  # IMAGE_FIT_TYPE_HORIZONTAL     = 2
  # IMAGE_FIT_TYPE_KEEP_RATIO     = 3
  # IMAGE_FIT_TYPE_IGNORE_RATIO   = 4
  # IMAGE_FIT_TYPE_REPEAT_MUTIPLE = 5
  # IMAGE_CHANGE_BOX_SIZE         = 6 #change box size to fit image source as is at origin

  def opinion_profile_options
    profile_hash                  = {}
    profile_hash[:image_path]     = opinion_profile_pdf_path
    profile_hash[:column]         = 1
    profile_hash[:row]            = 1
    if reporter == '내일시론'
      profile_hash[:extra_height_in_lines]= -3 # 7+5=12 lines
    else
      profile_hash[:extra_height_in_lines]= 5 # 7+5=12 lines
    end
    profile_hash[:stroke_width]   = 0
    profile_hash[:position]       = 1
    profile_hash[:is_float]       = true
    profile_hash[:fit_type]       = 2 # IMAGE_FIT_TYPE_HORIZONTAL
    profile_hash[:before_title]   = true
    profile_hash[:layout_expand]  = nil
    profile_hash
  end

  def editorial_profile_pdf_path
    publication.path + "/profile/#{reporter}.pdf"
  end

  def editorial_image_options
    profile_hash                          = {}
    profile_hash[:image_path]             = editorial_profile_pdf_path
    profile_hash[:inside_first_column]    = true
    profile_hash[:width_in_colum]         = 'half'
    profile_hash[:image_height_in_line]   = 7
    profile_hash[:bottom_room_margin]     = 2
    profile_hash[:extra_height_in_lines]  = 5 # 7+5=12 lines
    profile_hash[:stroke_width]           = 0
    profile_hash[:is_float]               = true
    profile_hash[:fit_type]               = 4
    profile_hash[:before_title]           = true
    profile_hash[:layout_expand]          = nil
    profile_hash
  end

  def image_options
    if images.first
      images.first.iamge_layout_hash
    else
      nil
    end
  end

  def image_box_options
    if images.first
      images.first.iamge_layout_hash
    else
      nil
    end  end

  def page_columns
    page.column
  end

  # def grid_width
  #   publication.grid_width(page_columns)
  # end

  def grid_height
    publication.grid_height
  end

  def gutter
    publication.gutter
  end

  def width
    column*grid_width
  end

  def height
    row*grid_height
  end

  def x
    grid_x*grid_width
  end

  def y
    grid_y*grid_height
  end

  def layout_options
    h = {}
    h[:kind]                          = kind if kind
    h[:page_number]                   = page_number
    h[:stroke_width]                  = 1 if kind == '사설' || kind == 'editorial'
    h[:column]                        = column
    h[:row]                           = row
    h[:grid_width]                    = grid_width
    h[:grid_height]                   = grid_height
    h[:gutter]                        = gutter
    h[:on_left_edge]                  = on_left_edge
    h[:on_right_edge]                 = on_right_edge
    h[:is_front_page]                 = is_front_page
    h[:top_story]                     = top_story
    h[:top_story]                     = false   if kind == 'opinion' || kind == '기고' || kind == 'editorial' || kind == '사설'
    h[:top_position]                  = top_position
    h[:bottom_article]                = page.bottom_article?(self)
    h[:page_heading_margin_in_lines]  = page_heading_margin_in_lines

    h[:extended_line_count]           = extended_line_count if extended_line_count
    h[:pushed_line_count]             = pushed_line_count if pushed_line_count
    h[:quote_box_size]                = quote_box_size if show_quote_box?

    h[:article_bottom_spaces_in_lines]= 2         #publication.article_bottom_spaces_in_lines
    h[:article_line_thickness]        = 0.3       #publication.article_line_thickness
    h[:article_line_draw_sides]       = [0,0,0,0] #publication.article_line_draw_sides
    h[:draw_divider]                  = false     #publication.draw_divider
    h
  end

  def layout_rb
    # h = h.to_s.gsub("{", "").gsub("}", "")
    h = layout_options
    if kind == '사진'
      content = "RLayout::NewsImageBox.new(#{h}) do\n"
      if image_hash = image_options
        image_hash[:fit_type] = 3 # keep ratio
        image_hash[:expand] = [:width, :height]
        puts "image_hash:#{image_hash}"
        content += "  news_image(#{image_hash})\n"
      end
      content += "end\n"
    elsif kind == '만평'
      content = "RLayout::NewsComicBox.new(#{h}) do\n"
      if image_hash = image_options
        content += "  news_image(#{image_hash})\n"
      end
      content += "end\n"
    elsif kind == '사설' || kind == 'editorial'
      h[:article_line_draw_sides]  = [0,1,0,0]
      content = "RLayout::NewsArticleBox.new(#{h}) do\n"
      content += "  news_column_image(#{editorial_image_options})\n" if page_number == 22
      content += "end\n"
    elsif kind == '기고' || kind == 'opinion'
      h[:article_line_draw_sides]  = [0,1,0,1]
      content = "RLayout::NewsArticleBox.new(#{h}) do\n"
        content += "  news_image(#{opinion_profile_options})\n"
      content += "end\n"
    else
      content = "RLayout::NewsArticleBox.new(#{h}) do\n"
      if image_hash = image_options
        content += "  news_image(#{image_hash})\n"
      end
      content += "end\n"
    end
    content
  end

  def save_story
    File.open(story_path, 'w'){|f| f.write story_md}
  end

  def read_story
    File.open(story_path, 'r'){|f| f.read }
  end

  def save_layout
    File.open(layout_path, 'w'){|f| f.write layout_rb}
  end

  def library_images
    publication.library_images
  end

  def box_svg
    # "<a xlink:href='/working_articles/#{id}'><image xlink:href='#{jpg_image_path}' x='#{x}' y='#{y}' width='#{width}' height='#{height}' /></a>\n"
    # "<a xlink:href='/working_articles/#{id}'><image xlink:href='#{pdf_image_path}' x='#{x}' y='#{y}' width='#{width}' height='#{height}' /></a>\n"
    "<a xlink:href='/working_articles/#{id}'><rect fill-opacity='0.0' x='#{x}' y='#{y}' width='#{width}' height='#{height}' /></a>\n"
  end

  def box_xml
    # "<a xlink:href='/working_articles/#{id}'><image xlink:href='#{jpg_image_path}' x='#{x}' y='#{y}' width='#{width}' height='#{height}' /></a>\n"
    # "<a xlink:href='/working_articles/#{id}'><image xlink:href='#{pdf_image_path}' x='#{x}' y='#{y}' width='#{width}' height='#{height}' /></a>\n"
    "<a xlink:href='/working_articles/#{id}'><rect fill-opacity='0.0' x='#{x}' y='#{y}' width='#{width}' height='#{height}' /></a>\n"
  end


  def parse_story
    source      = read_story
    begin
      if (md = source.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m))
        @contents = md.post_match
        @metadata = YAML.load(md.to_s)
      else
        @contents = source
      end
    rescue => e
      puts "YAML Exception reading #filename: #{e.message}"
    end
    self.kind           = @metadata['kind'] || 'article'
    self.title          = @metadata['title']
    self.title_head     = @metadata['title_head'] || nil
    self.subtitle       = @metadata['subtitle']
    self.subtitle_head  = @metadata['subtitle_head'] || nil
    self.body           = @contents
    self.reporter       = @metadata['reporter']
    self.email          = @metadata['email']
    self.personal_image = @metadata['personal_image']
    self.image          = @metadata['image']
    self.quote          = @metadata['quote']
    self.subject_head   = @metadata['subject_head']
  end


  def parse_article_info
    if article_info_hash = article_info
      self.kind           = article_info_hash[:kind]
      self.column         = article_info_hash[:column]
      self.row            = article_info_hash[:row]
      self.is_front_page  = article_info_hash[:is_front_page]
      self.top_story      = article_info_hash[:top_story]
      self.top_position   = article_info_hash[:top_position]
    end
  end

  # private

  # parse working_article info from copied article_template files
  def parse_article
    if article_info
      parse_article_info
      parse_story
    else
      #code
    end
  end

  def top_story?
    return true if top_story
    return true if page.working_articles.first.kind != '기사' && order == 2
    false
  end

  def change_article(new_article)
    puts __method__
    self.article_id = new_article.id
    article_info_hash   = new_article.attributes
    article_info_hash   = Hash[article_info_hash.map{ |k, v| [k.to_sym, v] }]
    self.kind           = article_info_hash[:kind]
    self.grid_x         = article_info_hash[:grid_x]
    self.grid_y         = article_info_hash[:grid_y]
    self.column         = article_info_hash[:column]
    self.row            = article_info_hash[:row]
    self.on_left_edge   = article_info_hash[:on_left_edge]
    self.on_right_edge  = article_info_hash[:on_right_edge]
    self.is_front_page  = article_info_hash[:is_front_page]
    self.top_story      = article_info_hash[:top_story]
    self.top_position   = article_info_hash[:top_position]
    self.extended_line_count = article_info_hash[:extended_line_count] || 0
    self.pushed_line_count = article_info_hash[:pushed_line_count] || 0
    self.inactive       = false
    self.save
    generate_pdf
  end

  def growable?
    true
  end

  def filter_to_markdown(body_text)
    return unless body_text
    body_text.strip!
    # body_text.gsub!(/^\n\n/, "\n")
    body_text.gsub!(/\u200B/, "")
    body_text.gsub!(/^(\^|-\s)/, "")
    body_text.gsub!(/^\t/, "")
    body_text.gsub!(/^\n/, "")
    body_text.gsub!(/^\s/, "")
    body_text.gsub!(/^\u3000/, "")
    body_text.gsub!(/^\s*\n/m, "\n")
    body_text.gsub!(/^\s*#/, '#' )
    body_text.gsub!(/^\n/, "")
    body_text.gsub!(/(\n|\r\n)+/, "\n\n")
    body_text.gsub!(/^\./, "")
    # body_text.gsub!(/[.]\s\s\s+/, ".")
    # body_text.gsub!(/\.$\n\n/, ".")
    body_text
  end

  def newsml_issue_path
    "#{Rails.root}/public/1/issue/#{issue.date}/newsml"
  end

  def two_digit_ord
    order.to_s.rjust(2, "0")
  end

  def story_xml_filename
    date_without_minus = issue.date.to_s.gsub("-","")
    two_digit_page_number = page_number.to_s.rjust(2, "0")
    "#{date_without_minus}.011001#{two_digit_page_number}0000#{two_digit_ord}.xml"
  end

  def section_name_code
    case page.section_name
    when '1면'
      code = "0009"
    when '정치'
      code = "0002"
    when '행정'
      code = "0003"
    when '국제통일'
      code = "0004"
    when '금융'
      code = "0007"
    when '산업'
      code = "0006"
    when '기획'
      code= "0001"
    when '정책'
      code = "0005"
    when '오피니언'
      code = "0008"
    end
    code
  end

  def news_class_large_id
    case page.section_name
    when '1면'
      code = "9"
    when '정치'
      code = "2"
    when '행정'
      code = "3"
    when '국제통일'
      code = "4"
    when '금융'
      code = "7"
    when '산업'
      code = "6"
    when '기획'
      code= "1"
    when '정책'
      code = "5"
    when '오피니언'
      code = "8"
    end
    code
  end

  # def save_story_xml
  #   FileUtils.mkdir_p(newsml_issue_path) unless File.exist? newsml_issue_path
  #   path = "#{newsml_issue_path}/#{story_xml_filename}"
  #   story_xml.encode("utf-8").force_encoding("ANSI")
  #   File.open(path, 'w'){|f| f.write story_xml}
  # end

  #  - [ ] 유니코드 문자 EUC-KR 변환시 체크 https://www.compart.com/en/unicode/
  def covert_euckr_not_suported_chars
    title.strip!
    body.gsub!("\u200B", "")
    title.gsub!("\u200B", "")
    body.gsub!("\u2027", "\u00b7")
    body.gsub!("\u2024", "\u00b7")
    title.gsub!("\u00A0", " ")
    body.gsub!("\u2043", "-")
    body.gsub!("\u30FB", "\u00b7")
    body.gsub!("\u6DB8", "&#28088;")
    body.gsub!("\u9B92", "&#39826;")
    body.gsub!("\u00A0", " ")
    body.gsub!("\u2014", "&mdash;")
    title.gsub!("\u003C", "&lt;")
    title.gsub!("\u003E", "&gt;")
    body.gsub!("\u003C", "&lt;")
    body.gsub!("\u003E", "&gt;")
    body.gsub!("\uFF62", "&#65378;")
    body.gsub!("\uFF63", "&#65379;")
    body.gsub!("\u2613", "&#9747;")
  end

  def save_story_xml
    FileUtils.mkdir_p(newsml_issue_path) unless File.exist? newsml_issue_path
    path = "#{newsml_issue_path}/#{story_xml_filename}"
    covert_euckr_not_suported_chars
    File.open(path, 'w:euc-kr'){|f| f.write story_xml}
    save_xml_image
  end


  def opinion_image_path
    publication.path + "/opinion/images"
  end

  def profile_image_path
    publication.path + "/profile/images"
  end

  def image_source
    if page_number == 22
      if kind == '기고'
        person = OpinionWriter.where(name:reporter).first
        name = person.name
        filtered_name = name
        filtered_name = name.split("_").first if name.include?("_")
        filtered_name = name.split("=").first if name.include?("=")
        puts "filtered_name : #{filtered_name}"
        return opinion_image_path + "/#{filtered_name}.jpg"
      elsif kind == '사설'
        person = Profile.where(name:reporter).first
        if person
          name = person.name
          return profile_image_path + "/#{name}.jpg"
        else
          return nil
        end
      end
    elsif page_number == 23
      if kind == '기고'
        person = OpinionWriter.where(name:reporter).first
        name = person.name
        filtered_name = name
        filtered_name = name.split("_").first if name.include?("_")
        filtered_name = name.split("=").first if name.include?("=")
        return opinion_image_path + "/#{filtered_name}.jpg"
      elsif kind == '사설'
        return nil
        # person = reporter_from_body
        # name = person.gsub(" ","")[0..2]
        # return opinion_image_path + "/#{name}.jpg"
      end
    end
  end

  def save_xml_image
    source = image_source
    return if source.nil?
    target = newsml_issue_path + "/#{@photo_item}"
    system("cp #{source} #{target}")
  end

  def reporter_from_body
    return unless reporter
    body.match(/^# (.*)/)
    $1.to_s.sub("# ", "")
  end

  def story_xml
    story_erb_path = "#{Rails.root}/public/1/newsml/story_xml.erb"
    story_xml_template = File.open(story_erb_path, 'r'){|f| f.read}
    year  = issue.date.year
    month = issue.date.month.to_s.rjust(2, "0")
    day   = issue.date.day.to_s.rjust(2, "0")
    hour  = updated_at.hour.to_s.rjust(2, "0")
    min   = updated_at.min.to_s.rjust(2, "0")
    sec   = updated_at.sec.to_s.rjust(2, "0")
    page_info        = page_number.to_s.rjust(2,"0")
    updated_date      = "#{year}#{month}#{day}"
    updated_time      = "#{hour}#{min}#{sec}+0900"
    @date_and_time    = "#{updated_date}T#{updated_time}"
    @date_id          = updated_date
    @news_key_id      = "#{updated_date}.011001#{page_info}0000#{two_digit_ord}"
    @day_info         = "#{year}년#{month}월#{day}일"
    @media_info       = publication.name
    # @edition_info     = page_number.to_s.rjust(2,"0")
    # @page_info        = publication.paper_size
    @page_info        = page_number.to_s.rjust(2,"0")
    @jeho_info        = issue.number

    # if page.section_name = '오피니언'
    #   @news_title_info = '논설'
    # else
    #   @news_title_info  = page.section_name
    # end
    @news_title_info  = page.section_name
      # reporter_record   = Reporter.where(name:reporter).first
      # if reporter_record
      #   @post             = reporter_record.reporter_group.name
      #   @gija_id          = email.split("@").first
      #   @email            = email
      # else
      #   @post             = "소속팀"
      #   @gija_id          = "기자아이디"
      #   @email            = "기자이메일"
      # end
    @name           = reporter
      # if @name =~/_/
      # @name = @name.split("_")[0]
      # end

    opinion_writer  = OpinionWriter.where(name:@name).first
    if opinion_writer
      @work        = opinion_writer.work if opinion_writer.work
      @position       = opinion_writer.position if opinion_writer.position
      if @name =~/_/
        @name = @name.split("_")[0]
      end
      @by_line        = "<br><br>#{@name} #{@work} #{@position}"
      @caption        = "#{@name} #{@work} #{@position}"
    end
    # reporter_record   = Reporter.where(name:reporter).first
    if page_number == 22 && order == 2
      profile         = Profile.where(name:@name).first
      if profile
        @work        = profile.work if profile.work
        @position       = profile.position if profile.position
        if @name =~/_/
          @name = @name.split("_")[0]
        end
        @by_line        = "<br><br>#{@name} #{@work} #{@position}"
        @caption        = "#{@name} #{@work} #{@position}"
      end
    end
    if page_number == 23 && order == 2
      @name          = reporter_from_body
      @by_line       = ''
      @caption       = reporter_from_body
    end
    @section_name_code = section_name_code
    @name_plate       = subject_head
    unless @name_plate
      r = OpinionWriter.where(name: reporter).first
      puts r
      category_code = r.category_code
      @name_plate = r.title
    end

    @money_status     = "30"
    if page_number == 22
      if kind == '사설'
        if subject_head == '기고'
          category_code = 2401
          @money_status = "0"
        elsif subject_head == '정치시평'
          category_code = 2201
        # elsif subject_head == '경제시평'
        #   category_code = 2202
        end
      end
    elsif page_number == 23
      if kind == '사설'
        category_code= 2101
      end
    end
    @name_plate_code  = category_code
    @gisa_key         = "#{@date_id}001#{@page_info}#{two_digit_ord}"
    @head_line        = title
    @sub_head_line    = subtitle
    @body_content     = body.gsub(/^##(.*)\n/){"<b>#{$1}</b><br><br>"}
    title.gsub!("\u2024", "")
    puts "=================="
    if body.include?("\u2024")
      puts "body"
    elsif title.include?("\u2024")
      puts "title"
    end
    if quote && quote.include?("\u2024")
      puts "quote"
    end

    @body_content     = @body_content.gsub(/^#\s(.*)/){"#{$1}"}
    @data_content     = @body_content.gsub("\n\n"){"<br><br>"}
    @photo_item       = "#{@date_id}_#{@jeho_info}_#{@page_info}_#{two_digit_ord}.jpg"
    # if story_xml_template.include?("\u200B")
    #   binding.pry
    # end
    @page_number = page_number
    @order = order
    story_erb = ERB.new(story_xml_template)
    story_erb.result(binding)
    # story_erb = ERB.new(story_xml_template)
    # story_erb.result(binding)
  end

  def mobile_preview_xml_article_info
    year  = issue.date.year
    month = issue.date.month.to_s.rjust(2, "0")
    day   = issue.date.day.to_s.rjust(2, "0")
    hour  = updated_at.hour.to_s.rjust(2, "0")
    min   = updated_at.min.to_s.rjust(2, "0")
    sec   = updated_at.sec.to_s.rjust(2, "0")
    page_info        = page_number.to_s.rjust(2,"0")
    updated_date      = "#{year}#{month}#{day}"

    # if page.section_name = '오피니언'
    #   @news_title_info = '논설'
    # else
    #   @news_title_info  = page.section_name
    # end
      # reporter_record   = Reporter.where(name:reporter).first
      # if reporter_record
      #   @post             = reporter_record.reporter_group.name
      #   @gija_id          = email.split("@").first
      #   @email            = email
      # else
      #   @post             = "소속팀"
      #   @gija_id          = "기자아이디"
      #   @email            = "기자이메일"
      # end
    @name           = reporter
      # if @name =~/_/
      # @name = @name.split("_")[0]
      # end

    opinion_writer  = OpinionWriter.where(name:@name).first
    if opinion_writer
      @work        = opinion_writer.work if opinion_writer.work
      @position       = opinion_writer.position if opinion_writer.position
      if @name =~/_/
        @name = @name.split("_")[0]
      end
      @by_line        = "<br><br>#{@name} #{@work} #{@position}"
      @caption        = "#{@name} #{@work} #{@position}"
    end
    # reporter_record   = Reporter.where(name:reporter).first
    if page_number == 22 && order == 2
      profile         = Profile.where(name:@name).first
      if profile
        @work        = profile.work if profile.work
        @position       = profile.position if profile.position
        if @name =~/_/
          @name = @name.split("_")[0]
        end
        @by_line        = "<br><br>#{@name} #{@work} #{@position}"
        @caption        = "#{@name} #{@work} #{@position}"
      end
    end
    if page_number == 23 && order == 2
      @name          = reporter_from_body
      @by_line       = ''
      @caption       = reporter_from_body
    end
    @section_name_code = section_name_code
    @name_plate       = subject_head
    unless @name_plate
      # binding.pry
      r = OpinionWriter.where(name: reporter).first
      puts r
      category_code = r.category_code
      @name_plate = r.title
    end

    @money_status     = "30"
    if page_number == 22
      if kind == '사설'
        if subject_head == '기고'
          category_code = 2401
          @money_status = "0"
        elsif subject_head == '정치시평'
          category_code = 2201
        # elsif subject_head == '경제시평'
        #   category_code = 2202
        end
      end
    elsif page_number == 23
      if kind == '사설'
        category_code= 2101
      end
    end
    @name_plate_code  = category_code
    @gisa_key         = "#{@date_id}001#{@page_info}#{two_digit_ord}"
    @head_line        = title
    @sub_head_line    = subtitle
    @body_content     = body.gsub(/^##(.*)\n/){"<b>#{$1}</b><br><br>"}
    @body_content     = @body_content.gsub(/^#\s(.*)/){"#{$1}"}
    @data_content     = @body_content.gsub("\n\n"){"<br><br>"}
    @page_number = page_number
    @order = order

    @group_key        = "#{year}#{month}#{day}.011001#{page_info}00000#{@order}"
    @cms_file_name    = "#{year}#{month}#{day}00100#{page_info}#{@order}"
    @article_file_name = "#{year}#{month}#{day}011001#{page_info}00000000#{@order}"
    @gija_name        = "편집기자명" # 편집기자명
    @news_class_large_id    = news_class_large_id
    @news_class_large_name  = page.section_name
    @news_class_middle_id   = category_code
    @news_class_middle_name = subject_head
    @send_modify            = "0"  # 수정횟수
    @new_article            = "1" #뭘까?
    @photo_file_name        = "#{year}#{month}#{day}.011001#{page_info}00000#{@order}.01L.jpg"
    #해당기사 저자사진: 121 × 160 픽셀, 120 픽셀/인치
    #해당기사 그래픽은 .01L대신 .01S.jpg로 표시

article_info =<<EOF
    <ArticleInfo>
      <GroupKey><%= @group_key %></GroupKey>
      <CmsFileName><%= @cms_file_name %></CmsFileName>
      <CmsRelationName/>
      <ArticleFileName><%= @article_file_name %>.txt</ArticleFileName>
      <GisaNumberID/>
      <GisaRelationID/>
      <ByLine/>
      <Gija ID="0" Area="0" Name="<%= @gija_name %>" Email=""/>
      <NewsClass LargeID="<%= @news_class_large_id %>" LargeName="<%= @news_class_large_name %>" MiddleID="<%= @news_class_middle_id %>" MiddleName="<%= @news_class_middle_name %>"/>
      <SendModify><%= @send_modify %></SendModify>
      <NewArticle><%= @new_article %></NewArticle>
    </ArticleInfo>
EOF
    article = ""

    erb = ERB.new(article_info)
    article += erb.result(binding)
  end

  def mobile_preview_xml_three_component
    if page_number == 23 && order == 2
      three_component =<<EOF
      <TitleComponent>
        <MainTitle>[<%= @name_plate %>] <%= @head_line %></MainTitle>
      </TitleComponent>
      <ArticleComponent>
        <Content><![CDATA[<!--[[--image1--]]//--><%= @data_content %>
  <%= @by_line %>]]>
        </Content>
      </ArticleComponent>
    </Article>
EOF
    else
    three_component =<<EOF
    <TitleComponent>
      <MainTitle>[<%= @name_plate %>] <%= @head_line %></MainTitle>
    </TitleComponent>
    <ArticleComponent>
      <Content><![CDATA[<!--[[--image1--]]//--><%= @data_content %>
<%= @by_line %>]]>
      </Content>
    </ArticleComponent>
    <PhotoComponent>
     <PhotoItem>
       <ImageType>Image</ImageType>
         <Property ImgClass="[IMG01]" align="left" Class="일반" Size="Large"/>
          <PhotoFileName><%= @photo_file_name %></PhotoFileName>
          <DataContent><![CDATA[ <%= @caption %>]]></DataContent>
     </PhotoItem>
    </PhotoComponent>
  end
  </Article>
EOF
    end
    component = ""

    erb = ERB.new(three_component)
    component += erb.result(binding)
  end

  def xml_group_key_template
    # binding.pry
    @name_plate       = subject_head
    unless @name_plate
      # binding.pry
      r = OpinionWriter.where(name: reporter).first
      puts r
      category_code = r.category_code
      @name_plate = r.title
    end
    year  = issue.date.year
    month = issue.date.month.to_s.rjust(2, "0")
    day   = issue.date.day.to_s.rjust(2, "0")
    page_info        = page_number.to_s.rjust(2,"0")
    title.strip!
    @head_line        = title
    @head_line        = @head_line.gsub("\u201C", "&quot;")
    @head_line        = @head_line.gsub("\u201D", "&quot;")
    @head_line        = @head_line.gsub("\u0022", "&quot;")
    @head_line        = @head_line.gsub("\u003C", "&lt;")
    @head_line        = @head_line.gsub("\u003E", "&gt;")
    @order            = order
    @group_key        = "#{year}#{month}#{day}.011001#{page_info}00000#{@order}"
    container_xml_group_key=<<EOF
      <Group Key="<%= @group_key %>" CmsFileName="" Title="[<%= @name_plate %>] <%= @head_line %>"/>
EOF
      xml_group_key = ""
      erb = ERB.new(container_xml_group_key)
      xml_group_key += erb.result(binding)
  end

  def mobile_page_preview_path
    "#{Rails.root}/public/1/issue/#{issue.date.to_s}/mobile_page_preview/1001#{page_number}"
  end

  def save_mobile_xml_image
    source = image_source
    return if source.nil?
    target = mobile_page_preview_path + "/#{@photo_file_name}"
    system("cp #{source} #{target}")
  end


  def character_count_data_path
    publication.publication_info_folder + "/charater_count_data/#{Date.today.to_s}_#{page_number}_#{order}"
  end

  # we want to create a compiled database of actual character count on a working_article.
  # save a yaml file of actual instance character data
  # we can average them later as we gather more data
  def save_character_count
    info = article_info
    return unless info
    return unless info[:overflow] == 0

    useage_data   = Hash[attributes.map{ |k, v| [k.to_sym, v] }]
    useage_data.delete[:id]
    useage_data.delete[:updated_at]
    useage_data.delete[:updated_at]

    useage_data[:character_count] = character_count
    path = character_count_data_path
    File.open(path, 'w'){|f| f.write useage_data.to_yaml}
  end

  def calculate_fitting_image_size(image_column, image_row, image_extra_line)
    current_image_occupied_lines = image_column*image_row + image_column*image_extra_line
    room = empty_lines_count + current_image_occupied_lines
    if room == 0
      return image_info.dup
    elsif room > 0
      expand_line_count = room/image_info[0].to_i
      retunn []
    else

    end
    lines = empty_lines/current_image_column
  end

  private


  def init_atts
    unless article

    else
      article_info_hash   = article.attributes
      article_info_hash   = Hash[article_info_hash.map{ |k, v| [k.to_sym, v] }]
      self.kind           = article_info_hash[:kind]
      self.grid_x         = article_info_hash[:grid_x]
      self.grid_y         = article_info_hash[:grid_y]
      self.grid_width     = article_info_hash[:grid_width]
      self.grid_height    = article_info_hash[:grid_heights]
      self.gutter         = article_info_hash[:gutter]
      self.column         = article_info_hash[:column]
      self.row            = article_info_hash[:row]
      self.is_front_page  = article_info_hash[:is_front_page]
      self.top_story      = article_info_hash[:top_story]
      self.top_position   = article_info_hash[:top_position]
      self.inactive       = false
      if page_number == 22 && order == 2
        self.subject_head = '기고'
      elsif page_number == 23 && order == 2
        self.subject_head = '내일시론'
      end
      # self.page_path      = page.path
    end
    self.title          = '제목은 여기에 여기는 제목'
    self.subtitle       = '부제는 여기에 여기는 부제목 자리'
    self.reporter       = '홍길동'
    self.email          = 'gdhong@gmail.com'
    self.body =<<~EOF
    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.

    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.

    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.

    여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.

    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.

    EOF

  end
end
