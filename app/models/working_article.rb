# == Schema Information
#
# Table name: working_articles
#
#  id             :integer          not null, primary key
#  grid_x         :integer
#  grid_y         :integer
#  column         :integer
#  row            :integer
#  order          :integer
#  kind           :string
#  profile        :string
#  title          :text
#  title_head     :string
#  subtitle       :text
#  subtitle_head  :string
#  body           :text
#  reporter       :string
#  email          :string
#  personal_image :string
#  image          :string
#  quote          :text
#  subject_head   :string
#  on_left_edge   :boolean
#  on_right_edge  :boolean
#  is_front_page  :boolean
#  top_story      :boolean
#  top_position   :boolean
#  inactive       :boolean
#  article_id     :integer
#  page_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class WorkingArticle < ApplicationRecord
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

  def pdf_image_path
    "/#{publication.id}/issue/#{page.issue.date.to_s}/#{page.page_number}/#{order}/story.pdf"
  end

  def page_number
    page.page_number
  end

  def jpg_image_path
    "/#{publication.id}/issue/#{page.issue.date.to_s}/#{page.page_number}/#{order}/story.jpg"
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

  def generate_pdf
    save_article
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article . -custom=#{publication.name}"
    copy_outputs_to_site
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
    generate_pdf
    if line_count == 0
      remove_extended_line_count_from_config_yml
    else
      add_extended_line_count_to_config_yml(line_count)
    end
    update_page_pdf
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
    profile_hash[:fit_type]       = 3 #IMAGE_FIT_TYPE_KEEP_RATIO
    profile_hash[:before_title]   = true
    profile_hash[:layout_expand]  = nil
    profile_hash
  end

  def editorial_image_options
    profile_hash                          = {}
    profile_hash[:image_path]             = images.first.image_path if images.length > 0
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
      content += "  news_column_image(#{editorial_image_options})\n" if images.length > 0
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

  def remove_c_md
    c_md_path = path + "/c.md"
    FileUtils.rm(c_md_path) if File.exist?(c_md_path)
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

  # add extra empty line between paragraphs
  def to_markdown_para
    body.gsub!(/^(\^|-\s)/, "")
    body.gsub!(/^\s*\n/m, "\n")
    # body.gsub!(/^\W*#/, '#' )
    body.gsub!(/(\n|\r\n)+/, "\n\n")
    body.gsub!(/(\n|\r\n)+/, "\n\n")
    self.save
  end

  def growable?
    true
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
