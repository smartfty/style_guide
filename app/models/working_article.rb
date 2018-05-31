# == Schema Information
#
# Table name: working_articles
#
#  id                  :integer          not null, primary key
#  grid_x              :integer
#  grid_y              :integer
#  column              :integer
#  row                 :integer
#  order               :integer
#  kind                :string
#  profile             :string
#  title               :text
#  title_head          :string
#  subtitle            :text
#  subtitle_head       :string
#  body                :text
#  reporter            :string
#  email               :string
#  personal_image      :string
#  image               :string
#  quote               :text
#  subject_head        :string
#  on_left_edge        :boolean
#  on_right_edge       :boolean
#  is_front_page       :boolean
#  top_story           :boolean
#  top_position        :boolean
#  inactive            :boolean
#  extended_line_count :integer
#  pushed_line_count   :integer
#  article_id          :integer
#  page_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  quote_box_size      :integer
#  category_code       :integer
#
# Indexes
#
#  index_working_articles_on_article_id  (article_id)
#  index_working_articles_on_page_id     (page_id)
#

class WorkingArticle < ApplicationRecord
  attr_reader :time_stamp

  belongs_to :page
  belongs_to :article
  has_many :images
  # before_create :parse_article
  before_create :init_atts
  after_create :setup
  accepts_nested_attributes_for :images

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
    f = Dir.glob("#{path}/story*.pdf").first
    File.basename(f) if f
  end

  def latest_jpg_basename
    f = Dir.glob("#{path}/story*.jpg").first
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
    save_story
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


  def extend_line(line_count)
    return if line_count == extended_line_count
    self.extended_line_count = line_count
    self.save
    siblings.each do |sybling|
      sybling.push_line(line_count)
    end
    # generate_pdf
    generate_pdf_with_time_stamp
    page.generate_pdf_with_time_stamp

    if line_count == 0
      remove_extended_line_count_from_config_yml
    else
      add_extended_line_count_to_config_yml(line_count)
    end
    page.generate_pdf_with_time_stamp
  end


  def add_pushed_line_count_to_config_yml(line_count)
    config_path = page.config_path
    config_hash = YAML::load_file(config_path)
    frame_array = config_hash['story_frames'][order - 1]
    if frame_array.last =~/^extend/
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
    add_pushed_line_count_to_config_yml(line_count)
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
    generate_pdf
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
    h['quote']      = quote if quote_box_size.to_i > 0
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
    profile_hash[:extra_height_in_lines]= 5 # 7+5=12 lines
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

  def page_columns
    page.column
  end

  def grid_width
    publication.grid_width(page_columns)
  end

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

  def layout_rb
    page_heading_margin_in_lines = 0
    if top_position
        page_heading_margin_in_lines = publication.page_heading_margin_in_lines(page.page_number)
    end

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
    if h[:on_left_edge].nil?
      h[:on_left_edge] = false
      h[:on_left_edge] = true if grid_x == 0
    end
    h[:on_right_edge]                 = on_right_edge
    if h[:on_right_edge].nil?
      h[:on_right_edge] = false
      h[:on_right_edge] = true if h[:column] + grid_x == page.column
    end
    h[:is_front_page]                 = is_front_page
    h[:top_story]                     = top_story
    h[:top_story]                     = false   if kind == 'opinion' || kind == '기고' || kind == 'editorial' || kind == '사설'
    h[:top_position]                  = top_position
    h[:bottom_article]                = page.bottom_article?(self)
    h[:page_heading_margin_in_lines]  = page_heading_margin_in_lines
    h[:extended_line_count]           = extended_line_count if extended_line_count
    h[:pushed_line_count]             = pushed_line_count if pushed_line_count
    h[:quote_box_size]                = quote_box_size if show_quote_box?
    h[:article_bottom_spaces_in_lines]= publication.article_bottom_spaces_in_lines
    h[:article_line_thickness]        = publication.article_line_thickness
    h[:article_line_draw_sides]       = publication.article_line_draw_sides
    h[:draw_divider]                  = publication.draw_divider
    h
    # h = h.to_s.gsub("{", "").gsub("}", "")
    if kind == '사진'
      content = "RLayout::NewsImageBox.new(#{h}) do\n"
      if image_hash = image_options
        image_hash[:fit_type] = 4
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
    self.inactive       = false
    self.save
  end

  def growable?
    true
  end

  def filter_to_markdown(body_text)
    body_text.gsub!(/^(\^|-\s)/, "")
    body_text.gsub!(/^\t/, "")
    body_text.gsub!(/^\u3000/, "")
    body_text.gsub!(/^\s*\n/m, "\n")
    body_text.gsub!(/^\s*#/, '#' )
    body_text.gsub!(/(\n|\r\n)+/, "\n\n")
    body_text.gsub!(/(\n|\r\n)+/, "\n\n")
    body_text
  end

  def to_markdown_para
    body.gsub!(/^(\^|-\s)/, "")
    body.gsub!(/^\t/, "")
    body.gsub!(/^\u3000/, "")
    body.gsub!(/^\s*\n/m, "\n")
    body.gsub!(/^\s*#/, '#' )
    body.gsub!(/(\n|\r\n)+/, "\n\n")
    body.gsub!(/(\n|\r\n)+/, "\n\n")
    self.save
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

  def save_story_xml
    FileUtils.mkdir_p(newsml_issue_path) unless File.exist? newsml_issue_path
    path = "#{newsml_issue_path}/#{story_xml_filename}"
    File.open(path, 'w'){|f| f.write story_xml}
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
        return opinion_image_path + "/#{name}.jpg"
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
        return opinion_image_path + "/#{name}.jpg"
      elsif kind == '사설'
        person = Profile.where(name:reporter).first
        name = person.name
        return profile_image_path + "/#{name}.jpg"
      end
    end
  end

  def save_xml_image
    source = image_source
    target = newsml_issue_path + "/#{@photo_item}"
    system("cp #{source} #{target}")
  end

  def save_story_xml
    FileUtils.mkdir_p(newsml_issue_path) unless File.exist? newsml_issue_path
    path = "#{newsml_issue_path}/#{story_xml_filename}"
    File.open(path, 'w'){|f| f.write story_xml}
    save_xml_image
  end

  def reporter_from_body
    return unless reporter
    body.match(/^# (.*)/)
    $1
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

    if page.section_name = '오피니언'
      @news_title_info = '논설'
    else
      @news_title_info  = page.section_name
    end
    # @name             = reporter
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
    @by_line          = reporter
    # reporter_record   = Reporter.where(name:reporter).first
    if page_number == 23 && order == 2
      @by_line          = reporter_from_body
    end
    @section_name_code = section_name_code
    @name_plate       = subject_head
    unless @name_plate
      # binding.pry
      r = OpinionWriter.where(name: reporter).first
      @name_plate = r.title
    end

    if page_number == 22
      if kind == '사설'
        if subject_head == '기고'
          category_code = 2401
        elsif subject_head == '정치시평'
          category_code = 2201
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
    @data_content     = body.gsub(/^##(.*)\n/, "<b>#{$1}</b>")
    @photo_item       = "#{@date_id}_#{@jeho_info}_#{@page_info}_#{two_digit_ord}.jpg"
    story_erb = ERB.new(story_xml_template)
    story_erb.result(binding)
    story_erb = ERB.new(story_xml_template)
    story_erb.result(binding)
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
    article_info_hash   = article.attributes
    article_info_hash   = Hash[article_info_hash.map{ |k, v| [k.to_sym, v] }]
    self.kind           = article_info_hash[:kind]
    self.grid_x         = article_info_hash[:grid_x]
    self.grid_y         = article_info_hash[:grid_y]
    self.column         = article_info_hash[:column]
    self.row            = article_info_hash[:row]
    self.is_front_page  = article_info_hash[:is_front_page]
    self.top_story      = article_info_hash[:top_story]
    self.top_position   = article_info_hash[:top_position]
    self.inactive       = false
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
