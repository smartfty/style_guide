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
#  has_profile_image            :boolean
#  announcement_text            :string
#  announcement_column          :integer
#  announcement_color           :string
#  boxed_subtitle_type          :integer
#  boxed_subtitle_text          :string
#  subtitle_type                :string
#  overlap                      :text
#  embedded                     :boolean
#  heading_columns              :integer
#  quote_position               :integer
#  quote_x_grid                 :integer
#  quote_v_extra_space          :integer
#  quote_alignment              :string
#  quote_line_type              :string
#  quote_box_column             :integer
#  quote_box_type               :integer
#  quote_box_show               :boolean
#  y_in_lines                   :integer
#  height_in_lines              :integer
#  by_line                      :string
#  price                        :float
#  category_name                :string
#  subcategory_code             :string
#
# Indexes
#
#  index_working_articles_on_article_id  (article_id)
#  index_working_articles_on_page_id     (page_id)
#  index_working_articles_on_slug        (slug) UNIQUE
#

# by_line
# price
# category_code

class WorkingArticle < ApplicationRecord
  belongs_to :page
  belongs_to :article, optional: true
  has_many :images, dependent: :delete_all
  has_many :graphics, dependent: :delete_all
  # has_many :story_category
  # has_many :story_subcategory
  has_one :story
  before_create :init_atts
  after_create :setup
  accepts_nested_attributes_for :images
  include ArticleSplitable
  include PageSplitable
  include ArticleSwapable
  include RectUtiles
  include ArticleSaveXml
  include WorkingArticleAutofit
  include WorkingArticleLayout
  # extend FriendlyId
  # friendly_id :make_frinedly_slug, :use => [:slugged]
  attr_reader :time_stamp

  # def page_friendly_string
  #   page.friendly_string
  # end

  # when working_article is split, we need to bumped up folder names
  def bump_up_path
    base_name = File.basename(path)
    new_base = (base_name.to_i + 1).to_s
    new_path = File.dirname(path) + "/#{new_base}"
    system("mv #{path} #{new_path}")
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


  def latest_pdf_basename
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

  def image_path
    "/#{publication.id}/issue/#{page.issue.date.to_s}/images"
  end

  def article_info_path
    path + "/article_info.yml"
  end

  def issue
    page.issue
  end

  # stroy from same group
  def story_candidates
    Story.where(date: issue.date, group: page.section_name)
  end

  def approximate_char_count
    article.char_count
  end

  def change_story(new_story)
    # update content with new story content
    # ArticleWorker.perform(path, @time_stamp, '내일신문' )
  end

  # def run_generate_pdf
  #   ArticleWorker.new.perform(path, nil)
  # end

  def mac_pdf
    ArticleWorker.perform_async(path, nil)
  end

  def ruby_pdf
    ArticleRubyWorker.perform_async(path, nil)
  end

  def update_story_content(story)
    # update content with new story content
    # params['working_article']['title'] = @working_article.filter_to_title(params['working_article']['title'])
    # params['working_article']['subtitle'] = @working_article.filter_to_title(params['working_article']['subtitle'])
    # params['working_article']['body'] = @working_article.filter_to_markdown(params['w
    self.reporter       = story.reporter
    self.subject_head   = filter_to_title(story.subject_head) if story.subject_head
    self.title          = filter_to_title(story.title)
    self.subtitle       = filter_to_title(story.subtitle)
    self.body           = filter_to_markdown(story.body)
    self.price          = story.price  if story.price
    self.by_line        = story.by_line  if story.by_line
    self.category_code  = story.category_code  if story.category_code
    self.subcategory_code  = story.subcategory_code  if story.subcategory_code
    self.quote          = story.quote  if story.quote
    self.save
    save_article
    delete_old_files
    stamp_time
    generate_pdf_with_time_stamp
    page.generate_pdf_with_time_stamp
    update_reporter_story(story.body)
  end

  def update_reporter_story(body)
    if story
      story.update_story_from_article(body)
    end
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

  def delete_folder
    system("rm -rf #{path}")
  end

  def stamped_pdf_file
    path + "/story#{@time_stamp}.pdf"
  end

  def wait_for_stamped_pdf
    starting = Time.now
    times_up = starting + 60*1
    while !File.exist?(stamped_pdf_file)
      sleep(1)
      if Time.now > times_up
        puts "Waited for 5 seconds!!! Time is up brake"
        break
      end
    end
  end

  def generate_pdf_with_time_stamp
    save_article
    delete_old_files
    stamp_time
    # session[:time_stamp] = @stamp_time
    # system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article .  -custom=#{publication.name} -time_stamp=#{@time_stamp}"
    ArticleWorker.perform_async(path, @time_stamp)
    wait_for_stamped_pdf
  end

  def generate_pdf
    # @time_stamp =  true
    save_article
    ArticleWorker.perform_async(path, nil)

    # system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article . -custom=#{publication.name}"
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

  # sets extended_line_count as line_count
  def set_extend_line(line_count)
    return if line_count == extended_line_count
    self.extended_line_count = line_count
    self.save
    siblings.each do |sybling|
      sybling.push_line(line_count)
    end
    generate_pdf_with_time_stamp
    save_extended_line_count_to_config_yml(line_count)
    page.generate_pdf_with_time_stamp
  end

  def height_in_lines
    row*7 + extended_line_count - pushed_line_count
  end

  def to_y_in_lines
    row*7 - pushed_line_count
  end

  def y_in_line_to_row_and_lines(y_position_in_line)
    row = y_position_in_line/7
    pushed = y_position_in_line % 7
  end

  def update_extended_and_pushed
    self.pushed_line_count = 0 if self.pushed_line_count.nil?
    if pushed_line_count >= 7
      row_count              = pusheded_line_count/7
      new_pushed_line_count  = pusheded_line_count % 7
      self.grid_y            = grid_y + row_count
      self.pushed_line_count = new_pushed_line_count
      self.y_in_lines        = grid_y*7 + new_pushed_line_count
    else
      self.y_in_lines        = to_y_in_lines
    end

    self.extended_line_count = 0 if self.extended_line_count.nil?
    if extended_line_count >= 7
      row_count = extended_line_count/7
      new_extendted_line_count = extended_line_count % 7
      self.row += row_count
      self.extended_line_count = new_extendted_line_count
    end
    self.height_in_lines = self.row*7 + self.extended_line_count - y_in_lines
    self.save
  end

  def expandable?(line_count)
    expandable = false
    sybs = siblings
    sybs.each do |sybling|
      expandable = sybling.pushable?(line_count)
    end
    expandable
  end

  def pushable?(line_count)
    article_bottom_spaces_in_lines = 2
    if height_in_lines - line_count >= 7 
      return true
    elsif siblings.length > 0
      siblings.first.pushable?(line_count)
      return true
    end
    false
  end

  # adds extended_line_count with new line_count
  def extend_line(line_count, options={})
    sibs = siblings
    # return unless sibs.first.pushable?(line_count)
    return if line_count == 0
    if self.extended_line_count
      self.extended_line_count += line_count
    else
      self.extended_line_count = line_count
    end
    self.save
    sibs.each do |sybling|
      sybling.push_line(self.extended_line_count)
    end
    generate_pdf_with_time_stamp
    save_extended_line_count_to_config_yml(self.extended_line_count)
    page.generate_pdf_with_time_stamp unless options[:generate_pdf] == false
  end

  def save_extended_line_count_to_config_yml(line_count)
    config_path = page.config_path
    config_hash = YAML::load_file(config_path)
    frame_array = config_hash['story_frames'][order - 1]
    if frame_array.length == 4
        frame_array << {'extend'=> line_count} unless line_count == 0
    elsif frame_array.length >= 5 
      if  frame_array.last.class == Hash
        if line_count == 0
          frame_array.last.delete('extend')
          frame_array.pop if frame_array.last == {}
        else
          frame_array.last['extend'] = line_count
        end
      # support lagacy format
      elsif frame_array.last =~/^extend/
        frame_array.pop
        frame_array << {'extend'=> line_count}  unless line_count == 0
      else
        frame_array << {'extend'=> line_count}  unless line_count == 0
      end
    end
    File.open(config_path, 'w'){|f| f.write config_hash.to_yaml}
  end

  def save_pushed_line_count_to_config_yml(line_count)
    config_path = page.config_path
    config_hash = YAML::load_file(config_path)
    frame_array = config_hash['story_frames'][order - 1]
    if frame_array.length == 4
        frame_array << {'push'=> line_count} unless line_count == 0
    elsif frame_array.length >= 5 
      if  frame_array.last.class == Hash
        if line_count == 0
          frame_array.last.delete('push')
          frame_array.pop if frame_array.last == {}
        else
          frame_array.last['push'] = line_count
        end
      # support lagacy format
      elsif frame_array.last =~/^push/
        frame_array.pop
        frame_array << {'push'=> line_count}  unless line_count == 0
      else
        frame_array << {'push'=> line_count}  unless line_count == 0
      end
    end
    File.open(config_path, 'w'){|f| f.write config_hash.to_yaml}
  end

  def save_pushed_sibllings_to_config_yml(line_count, sibllings_list)

  end

  def push_box_y_position(line_count, options={})
    # update config file
    # do not update layout, just move the position in the page
    # this is much quicker operation

  end

  def push_sibllings_by_y_position(line_count, options={})
    # options remove_last_if_pushed_out
    # options remove_last_if_less_than_single_row

    # if last siblling is pushed out of page, remove_last_if_pushed_out
    #
    line_count = 1
    sibllings_list = [3, 5] # order of sibllings

    save_pushed_sibllings_to_config_yml(line_count, sibllings_list)
  end

  def push_line(line_count, options={})
    self.pushed_line_count = line_count
    self.save
    generate_pdf_with_time_stamp
    save_pushed_line_count_to_config_yml(self.pushed_line_count)
  end

  def empty_lines_count
    h = article_info
    return nil unless h
    h[:empty_lines]
  end

  def overflow?
    overflow_line_count
  end

  def underflow?
    empty_lines_count
  end

  def overflow_line_count
    h = article_info
    return nil unless h
    h[:overflow_line_count]
  end

  def show_quote_box?
    quote_box_show
  end
  
  def show_quote_box(quote_box_type)
    self.quote_box_show = true
    self.quote_box_type = quote_box_type
    case quote_box_type
    when '일반' || 'reqular'
      self.quote_box_size = 4
    when '기고2행' || 'opinion2'
      self.quote_box_size = 2
    when '기고3행' || 'opinion3'
      self.quote_box_size = 3
    end
    self.save
  end

  def hide_quote_box
    self.quote_box_show = false
    self.save
  end
 
  def boxed_subtitle_zero
    self.boxed_subtitle_type = 0
    self.save
  end

  def boxed_subtitle_one
    self.boxed_subtitle_type = 1
    self.save
  end

  def boxed_subtitle_two
    self.boxed_subtitle_type = 2
    self.save
  end

  def announcement_zero
    self.announcement_column = 0
    self.save
  end

  def announcement_one
    self.announcement_column = 1
    self.save
  end

  def announcement_two
    self.announcement_column = 2
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
    # binding.pry
    h = {}
    h['extended_line_count']  = extended_line_count if extended_line_count && extended_line_count > 0
    h['pushed_line_count']    = pushed_line_count if pushed_line_count && pushed_line_count > 0
    h['subject_head']         = RubyPants.new(subject_head).to_html if subject_head && subject_head !=""
    h['title']                = RubyPants.new(title).to_html if title
    if subtitle
      h['subtitle']           = RubyPants.new(subtitle).to_html unless (kind == '사설' || kind == '기고')
    end
    h['boxed_subtitle_text']  = RubyPants.new(boxed_subtitle_text).to_html if boxed_subtitle_type && boxed_subtitle_type.to_i > 0
    h['quote']                = RubyPants.new(quote).to_html  if quote && quote !="" if quote_box_size.to_i > 0
    h['announcement']         = RubyPants.new(announcement_text).to_html  if announcement_column && announcement_column > 0
    h['reporter']             = reporter if reporter &&  reporter !=""
    h['email']                = email
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
    #{RubyPants.new(body).to_html if body}
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
      images.first.image_layout_hash
    else
      nil
    end
  end

  def image_box_options
    if images.first
      images.first.image_layout_hash
    else
      nil
    end  end

  def page_columns
    page.column
  end

  def grid_frame
    [grid_x, grid_y, column, row]
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
    h = row*grid_height
    if top_position?
      h -= page_heading_margin_in_lines*body_line_height
    end
    if pushed_line_count && pushed_line_count != 0
      h -= pushed_line_count*body_line_height
    end
    if extended_line_count && extended_line_count != 0
      h += extended_line_count*body_line_height
    end
    h
  end

  def grid_area
    grid_x*grid_y
  end

  def x
    grid_x*grid_width
  end

  #TODO add to db field

  def body_line_height
    grid_height/7
  end

  def y
    y_position =  grid_y*grid_height
    if top_position?
      y_position += page_heading_margin_in_lines*body_line_height
    elsif pushed_line_count && pushed_line_count != 0
      y_position += pushed_line_count*body_line_height
    end
    y_position
  end

  # def top_story?
  #   page.page_number == 1 && order == 1
  # end

  #TODO
  def top_story?
    return true if top_story
    return true if page.working_articles.first.kind != '기사' && order == 2
    false
  end

  def top_position?
    return true if grid_y == 0
    return true if grid_y == 1 && page.page_number == 1
    false
  end

  # def get_page_heading_margin_in_lines
  #   return 0 unless top_position?
  #   page.page_heading_margin_in_lines
  #   n
  # end

  def image_layout_hash
    h = {}
    h[:kind]                          = self.kind if kind
    h[:subtitle_type]                 = self.subtitle_type || '1단'
    h[:heading_columns]               = self.heading_columns if  heading_columns && heading_columns!= column && heading_columns != ""
    if kind == '사설' || kind == 'editorial'
        h[:has_profile_image]             = true if reporter
        h[:has_profile_image]             = false if reporter == ""
    end
    h[:page_number]                   = self.page_number
    h[:stroke_width]                  = 1 if kind == '사설' || kind == 'editorial'
    h[:column]                        = self.column
    h[:row]                           = self.row
    h[:grid_width]                    = self.grid_width
    h[:grid_height]                   = self.grid_height
    h[:gutter]                        = self.gutter
    h[:on_left_edge]                  = self.on_left_edge
    h[:on_right_edge]                 = self.on_right_edge
    h[:is_front_page]                 = self.is_front_page
    h[:top_story]                     = top_story?
    h[:top_story]                     = false   if kind == 'opinion' || kind == '기고' || kind == 'editorial' || kind == '사설'
    h[:top_position]                  = top_position?
    h[:page_heading_margin_in_lines]  = publication.page_heading_margin_in_lines(page.page_number)
    h[:bottom_article]                = page.bottom_article?(self)
    h[:extended_line_count]           = self.extended_line_count if extended_line_count
    h[:pushed_line_count]             = self.pushed_line_count if pushed_line_count
    if boxed_subtitle_type && boxed_subtitle_type > 0
      h[:boxed_subtitle_type]         = self.boxed_subtitle_type
    end
    if announcement_column && announcement_column > 0
      h[:announcement_column]         = self.announcement_column
      h[:announcement_color]          = self.announcement_color
    end
    if show_quote_box?
      h[:quote_box_size]              = self.quote_box_size 
      h[:quote_position]              = self.quote_position || 5 
      h[:quote_x_grid]                = self.quote_x_grid  - 1 if self.quote_x_grid
      h[:quote_v_extra_space]         = self.quote_v_extra_space || 0
      h[:quote_alignment]             = self.quote_alignment || 'left'
      h[:quote_line_type]             = self.quote_line_type || '상하' #'박스'
      h[:quote_box_type]              = self.quote_box_type || '일반' #'일반, 기고2행, 기고3행'
      h[:quote_box_column]            = self.quote_box_column || 1
    end
    h[:article_bottom_spaces_in_lines]= 2         #publication.article_bottom_spaces_in_lines
    h[:article_line_thickness]        = 0.3       #publication.article_line_thickness
    h[:article_line_draw_sides]       = [0,0,0,1] #publication.article_line_draw_sides
    h[:draw_divider]                  = false     #publication.draw_divider
    h[:overlap]                       = overlap   if overlap
    h[:embedded]                      = embedded  if embedded
    h
  end

  def image_layout
    content = ""
    images.each do |image|
      content += "  news_image(#{image.image_layout_hash})\n"
    end
    content
  end

  def graphic_layout
    content = ""
    graphics.each do |graphic|
      content += "  news_image(#{graphic.graphic_layout_hash})\n"
    end
    content
  end

  def quote_layout
    quote_hash = {}
    # quote_hash[:quote]            = quote
    quote_hash[:position]         = quote_position || 1
    quote_hash[:x_grid]           = quote_x_grid
    quote_hash[:column]           = quote_box_size || 1
    quote_hash[:row]              = 1
    quote_hash[:v_extra_space]    = quote_v_extra_space
    quote_hash[:text_alignment]   = quote_alignment || 'left'
    quote_hash[:line_type]        = quote_line_type || '상하'
    "  news_quote(#{quote_hash})\n"
  end

  def layout_rb
    # h = h.to_s.gsub("{", "").gsub("}", "")
    h = image_layout_hash
    if kind == '사진'
      if first_image = images.first
        h[:draw_frame] = false if first_image && first_image.draw_frame == false
        content = "RLayout::NewsImageBox.new(#{h}) do\n"
        image_hash = image_options
        # image_hash[:fit_type] = 3 # keep ratio
        image_hash[:expand] = [:width, :height]
        content += "  news_image(#{image_hash})\n"
        content += "end\n"
      elsif first_graphic = graphics.first 
        h[:draw_frame] = false if first_graphic && first_graphic.draw_frame == false
        content = "RLayout::NewsImageBox.new(#{h}) do\n"
        image_hash = first_graphic.graphic_layout_hash
        # image_hash[:fit_type] = 3 # keep ratio
        image_hash[:expand] = [:width, :height]
        content += "  news_image(#{image_hash})\n"
        content += "end\n"
      else
        h[:draw_frame] = true
        content = "RLayout::NewsImageBox.new(#{h}) do\n"
        # image_hash[:fit_type] = 3 # keep ratio
        # image_hash[:expand] = [:width, :height]
        # content += "  news_image(#{image_hash})\n"
        content += "end\n"
      end
    elsif kind == '만평'
      content = "RLayout::NewsComicBox.new(#{h}) do\n"
      if image_hash = image_options
        content += "  news_image(#{image_hash})\n"
      end
      content += "end\n"
    elsif kind == '사설' || kind == 'editorial'
      h[:article_line_draw_sides]  = [0,1,0,0]
      content = "RLayout::NewsArticleBox.new(#{h}) do\n"
      content += "  news_column_image(#{editorial_image_options})\n" if reporter && reporter != "" # if page_number == 22
      content += "end\n"
    elsif kind == '기고' || kind == 'opinion'
      h[:article_line_draw_sides]  = [0,1,0,1]
      content = "RLayout::NewsArticleBox.new(#{h}) do\n"
        content += "  news_image(#{opinion_profile_options})\n"
      content += "end\n"
    else
      content = "RLayout::NewsArticleBox.new(#{h}) do\n"
      if images.length > 0
        content += image_layout
      end
      if graphics.length > 0
        content += graphic_layout
      end
      # if quote && quote != ""
      #   content += quote_layout
      # end
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
    layout = layout_rb
    File.open(layout_path, 'w'){|f| f.write layout}
  end

  def library_images
    publication.library_images
  end

  def box_svg
    # "<a xlink:href='/working_articles/#{id}'><image xlink:href='#{jpg_image_path}' x='#{x}' y='#{y}' width='#{width}' height='#{height}' /></a>\n"
    # "<a xlink:href='/working_articles/#{id}'><image xlink:href='#{pdf_image_path}' x='#{x}' y='#{y}' width='#{width}' height='#{height}' /></a>\n"
    # "<a xlink:href='/working_articles/#{id}'><rect stroke='black' stroke-width='5' fill-opacity='0.0' x='#{x}' y='#{y}' width='#{width}' height='#{height}' /></a>\n"
    svg = "<text fill-opacity='0.5' fill='#777' y='#{y + height/2 + 50}' stroke-width='0' ><tspan font-size='150' x='#{x + width/2}' text-anchor='middle'>#{order}</tspan><tspan font-size='30' x='#{x + width/2}' text-anchor='middle' dy='40'> </tspan></text>"
    svg += "<a xlink:href='/working_articles/#{id}'><rect class='rectfill' stroke='black' stroke-width='0' fill-opacity='0.0' x='#{x}' y='#{y}' width='#{width}' height='#{height}' /></a>\n"
  end

  def story_svg
    svg = "<text fill-opacity='0.5' fill='#777' y='#{y + height/2 + 50}' stroke-width='0' ><tspan font-size='150' x='#{x + width/2}' text-anchor='middle'>#{order}</tspan><tspan font-size='30' x='#{x + width/2}' text-anchor='middle' dy='40'> </tspan></text>"
    svg += "<a xlink:href='/working_articles/#{id}/change_story'><rect class='rectfill' stroke='black' stroke-width='0' fill-opacity='0.0' x='#{x}' y='#{y}' width='#{width}' height='#{height}' /></a>\n"
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
    self.subtitle_head  = @metadata['subtitle_type'] || nil
    self.body           = @contents
    self.reporter       = @metadata['reporter']
    self.email          = @metadata['email']
    self.has_profile_image = @metadata['has_profile_image']
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

  # parse working_article info from copied article_template files
  def parse_article
    if article_info
      parse_article_info
      parse_story
    else
      #code
    end
  end

  def change_article(new_article)
    self.article_id = new_article.id
    article_info_hash   = new_article.attributes
    article_info_hash   = Hash[article_info_hash.map{ |k, v| [k.to_sym, v] }]
    self.kind           = article_info_hash[:kind]
    self.grid_x         = article_info_hash[:grid_x]
    self.grid_y         = article_info_hash[:grid_y]
    self.grid_width     = article_info_hash[:grid_width]
    self.grid_height    = article_info_hash[:grid_height]
    self.column         = article_info_hash[:column]
    self.row            = article_info_hash[:row]
    self.on_left_edge   = article_info_hash[:on_left_edge]
    self.on_right_edge  = article_info_hash[:on_right_edge]
    self.is_front_page  = article_info_hash[:is_front_page]
    self.top_story      = article_info_hash[:top_story]
    self.top_position   = article_info_hash[:top_position]
    self.extended_line_count = article_info_hash[:extended_line_count] || article_info_hash[:extended] || 0
    self.pushed_line_count = article_info_hash[:pushed_line_count] || article_info_hash[:pushed] || 0
    self.page_heading_margin_in_lines = article_info_hash[:page_heading_margin_in_lines]
    self.inactive       = false
    self.overlap        = article_info_hash[:overlap]
    self.save
  end

  def growable?
    true
  end

  def section_name_code
    case page.section_name
    when '1면'
      code = "0009"
    when '정치'
      code = "0002"
    when '자치행정'
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
  
  def group_name
    case page.section_name
    when '1면'
      code = "first_group"
    when '정치'
      code = "second_group"
    when '자치행정'
      code = "third_group"
    when '국제통일'
      code = "fourth_group"
    when '금융'
      code = "fifth_group"
    when '산업'
      code = "sixth_group"
    when '기획'
      code= "senventh_group"
    when '정책'
      code = "eighth_group"
    when '오피니언'
      code = "nineth_group"
    else
      code = "first_group"
    end

  end

  def news_class_large_id
    case page.section_name
    when '1면'
      code = "9"
    when '정치'
      code = "2"
    when '자치행정'
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

  def opinion_image_path
    publication.path + "/opinion/images"
  end

  def profile_image_path
    publication.path + "/profile/images"
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
    room = empty_lines_count
    image_info = [image_column, image_row, image_extra_line]
    if room < image_column
      # current image size is good fit
      return [image_column, image_row, image_extra_line]
    elsif room >= image_column
      # There is a room, so image size can grow
      extra_line_count = room % image_column
      extra_line_sum = extra_line_count  + image_extra_line
      if extra_line_sum > 7
        extra_rows = (extra_line_sum/7).to_i
        extra_lines = extra_line_sum % 7
        return [image_column, image_row + extra_rows, extra_lines]
      else
        extra_lines = extra_line_sum % 7
        return [image_column, image_row, extra_lines]
      end
    else
      # There is an overflow, so image size should be reduced
      current_image_occupied_lines = image_column*image_row*7 + image_column*image_extra_line
      overflow_row_count = (overflow_line_count/(image_column*7)).to_i
      overflow_extra_lines = overflow_line_count % image_column
      overflow_extra_lines_sum = overflow_extra_lines - image_extra_line
      if overflow_line_count > current_image_occupied_lines || overflow_row_count >= image_row
        # over flow is greater than the total image ares, so make the image as small as we can
        return [1,1,0]
      else
        return  [image_column, reducing_rows - overflow_row_count, overflow_extra_lines_sum]
      end
    end
  end

  def create_image_place_holder(column, row)
    image_hash                      = {}
    image_hash[:working_article_id] = id
    image_hash[:column]             = column
    image_hash[:row]                = row
    image_hash[:position]           = 3
    place_holder = Image.where(image_hash).first_or_create
    return true if place_holder
  end

  def create_place_holder_graphic(column, row)
    image_hash                      = {}
    image_hash[:working_article_id] = id
    image_hash[:column]             = column
    image_hash[:row]                = row
    image_hash[:position]           = 3
    place_holder = Graphic.where(image_hash).first_or_create
    return true if place_holder
  end


  # this is called when story was un_assigned from working_article
  def clear_story
    self.title          = "#{order}번 제목은 여기에 여기는 제목"
    self.subtitle       = '부제는 여기에 여기는 부제목 자리'
    self.reporter       = ''
    self.email          = 'gdhong@gmail.com'
    self.body =<<~EOF
    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.
    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.
    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.
    여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.
    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.
    EOF
    self.save
    generate_pdf_with_time_stamp
    page.generate_pdf_with_time_stamp
  end

  def layout_info
    layout_info = [grid_x, grid_y, column, row]
    h = {}
    if kind != '기사'
      h = {kind: kind}
    end
    h[:extended]  = extended_line_count if extended_line_count && extended_line_count != 0
    h[:pushed]    = pushed_line_count   if pushed_line_count && pushed_line_count != 0
    if images.length > 0
      h[:images] = []
      images.each do |image|
        h[:images] << image.info
      end
    end
    if graphics.length > 0
      h[:graphics] = []
      graphics.each do |graphic|
        h[:graphics] << graphic.info
      end
    end
    layout_info << h unless h == {}
    layout_info
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
      self.grid_width     = page.grid_width
      self.grid_height    = page.grid_height
      self.gutter         = article_info_hash[:gutter]
      self.column         = article_info_hash[:column]
      self.row            = article_info_hash[:row]
      self.is_front_page  = article_info_hash[:is_front_page]
      self.on_left_edge   = article_info_hash[:on_left_edge]
      self.on_right_edge  = article_info_hash[:on_right_edge]
      self.top_story      = article_info_hash[:top_story]
      self.top_position   = article_info_hash[:top_position]
      self.page_heading_margin_in_lines = page.page_heading_margin_in_lines

      self.inactive       = false
      if page_number == 22 && order == 2
        self.subject_head = '기고'
      elsif page_number == 23 && order == 2
        self.subject_head = '내일시론'
      end
      # self.page_path      = page.path
    end
    self.title          = "#{order}번 제목은 여기에 여기는 제목"
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
