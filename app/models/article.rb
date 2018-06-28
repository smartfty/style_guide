# == Schema Information
#
# Table name: articles
#
#  id             :integer          not null, primary key
#  grid_x         :integer
#  grid_y         :integer
#  column         :integer
#  row            :integer
#  order          :integer
#  kind           :string
#  profile        :integer
#  title_head     :string
#  title          :text
#  subtitle       :text
#  subtitle_head  :text
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
#  section_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Article < ApplicationRecord
  belongs_to :section #, optional: true

  after_create :setup

  has_many :images

  def path
    section.path + "/#{order}"
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

  def relative_path
    section.relative_path + "/#{order}"
  end

  def pdf_image_path
    relative_path + "/story.pdf"
  end

  def jpg_image_path
    relative_path + "/output.jpg"
  end

  def custom_pdf_path
    path + "/custom_style.pdf"
  end

  def custom_jpg_path
    path + "/custom_style.jpg"
  end

  def custom_pdf_image_path
    relative_path + "/custom_style.pdf"
  end

  def custom_jpg_image_path
    relative_path + "/custom_style.end"
  end

  def article_info_path
    path + "/article_info.yml"
  end

  def publication
    section.publication
  end

  def create_folders
    system "mkdir -p #{path}" unless File.directory?(path)
    system "mkdir -p #{images_path}" unless File.directory?(images_path)
  end

  def setup
    create_folders
    save_story
    save_layout
  end

  def save_article
    save_story
    save_layout
  end

  # aooorcimation of character_count
  def char_count
    column*row*7*15
  end

  def update_pdf_unless
    unless File.exist?(pdf_path)
      system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
    end
  end

  def update_pdf
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
  end

  def generate_pdf
    save_story
    save_layout
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article . -custom=#{publication.name}"

    # system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
  end

  def generate_custom_style_pdf(current_styles)
    puts __method__
    styles_path     = path + "/custom_style.yml"
    File.open(styles_path, 'w'){|f| f.write current_styles.to_yaml}
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article . -custom=#{publication.name}"
  end

  def article_info
    if File.exist?(article_info_path)
      return @article_info_hash ||= YAML::load(File.open(article_info_path, 'r'){|f| f.read})
    else
      puts "#{article_info_path} does not exist!!!"
      return nil
    end
  end

  def story_md
    title     = '제목은 여기에 여기는 제목'
    subtitle  = '부제는 여기에 여기는 부제목 자리'
    reporter  = '홍길동'
    email     = 'gdhong@gmail.com'

    body =<<~EOF
    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.

    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.

    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.

    여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.

    여기는 본문이 입니다 본문을 여기에 입력 하시면 됩니다. 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.

    EOF

    quote           = "여기에 발문 입력 합니다.\r\n. 이부분은 본문 중간에 위치 하게 됩니다."
    extra_paragraph = "\n#{quote}"*3

    if kind == '기고'
      story_md =<<~EOF
      ---
      title: #{title}
      reporter: #{reporter}
      email: #{email}
      ---

      #{body}

      EOF

    elsif kind == '사설' && page_number == 22
      story_md =<<~EOF
      ---
      subject_head: 기고
      title: #{title}
      email: #{email}
      ---

      #{body}

      EOF
    elsif kind == '사설' && page_number == 23
      story_md =<<~EOF
      ---
      subject_head: 내일시론
      title: #{title}
      email: #{email}
      ---

      #{body}

      EOF

    else
      story_md =<<~EOF
      ---
      title: #{title}
      subtitle: #{subtitle}
      reporter: #{reporter}
      email: #{email}
      ---

      #{body}

      EOF
    end
  end

  def image_options
    #code
    if images.first
      images.first.iamge_layout_hash
    else
      nil
    end
  end

  #
  # def layout_rb
  #   page_heading_margin_in_lines = 0
  #   if top_position && is_front_page
  #       page_heading_margin_in_lines = publication.page_heading_margin_in_lines(1)
  #   elsif top_position
  #       page_heading_margin_in_lines = 3
  #   end
  #
  #   h = {}
  #   h[:kind]                          = kind if kind
  #   h[:stroke_width]                  = 1 if kind == '사설' || kind == 'editorial'
  #   h[:column]                        = column
  #   h[:row]                           = row
  #   h[:grid_width]                    = publication.grid_width(column)
  #   h[:grid_height]                   = publication.grid_height
  #   h[:gutter]                        = publication.gutter
  #   h[:on_left_edge]                  = on_left_edge
  #   if h[:on_left_edge].nil?
  #     h[:on_left_edge] = false
  #     h[:on_left_edge] = true if grid_x == 0
  #   end
  #   h[:on_right_edge]                 = on_right_edge
  #   if h[:on_right_edge].nil?
  #     h[:on_right_edge] = false
  #     h[:on_right_edge] = true if h[:column] + grid_x == page.column
  #   end
  #   h[:is_front_page]                 = is_front_page
  #   h[:top_story]                     = top_story
  #   h[:top_story]                     = false   if kind == 'opinion' || kind == '기고' || kind == 'editorial' || kind == '사설'
  #   h[:top_position]                  = top_position
  #   h[:page_heading_margin_in_lines]  = page_heading_margin_in_lines
  #   h[:article_bottom_spaces_in_lines]= publication.article_bottom_spaces_in_lines
  #   h[:article_line_thickness]        = publication.article_line_thickness
  #   h[:article_line_draw_sides]       = publication.article_line_draw_sides
  #   h[:draw_divider]                  = publication.draw_divider
  #   h
  #   # h = h.to_s.gsub("{", "").gsub("}", "")
  #   if kind == '사진'
  #     content = "RLayout::NewsImageBox.new(#{h}) do\n"
  #     if image_hash = image_options
  #       image_hash[:fit_type] = 4
  #       image_hash[:expand] = [:width, :height]
  #       puts "image_hash:#{image_hash}"
  #       content += "  news_image(#{image_hash})\n"
  #     end
  #     content += "end\n"
  #   elsif kind == '만평'
  #     content = "RLayout::NewsComicBox.new(#{h}) do\n"
  #     if image_hash = image_options
  #       content += "  news_image(#{image_hash})\n"
  #     end
  #     content += "end\n"
  #   elsif kind == '사설' || kind == 'editorial'
  #     h[:article_line_draw_sides]  = [0,1,0,0]
  #     content = "RLayout::NewsArticleBox.new(#{h}) do\n"
  #       # content += "  news_image(#{opinion_profile_options})\n"
  #     content += "end\n"
  #   elsif kind == '기고' || kind == 'opinion'
  #     h[:article_line_draw_sides]  = [0,1,0,1]
  #     content = "RLayout::NewsArticleBox.new(#{h}) do\n"
  #       content += "  news_image(#{opinion_profile_options})\n"
  #     content += "end\n"
  #   else
  #     content = "RLayout::NewsArticleBox.new(#{h}) do\n"
  #     if image_hash = image_options
  #       content += "  news_image(#{image_hash})\n"
  #     end
  #     content += "end\n"
  #   end
  #   content
  # end

  def page_number
    section.page_number
  end

  def layout_rb
    grid_width    = publication.grid_width(page_columns)
    grid_height   = publication.grid_height
    gutter        = publication.gutter
    image_options = image_options if image_options
    page_heading_margin_in_lines = 0
    if top_position
      if is_front_page
        # front_page_heading_height - lines_per_grid
        page_heading_margin_in_lines = publication.front_page_heading_margin
      elsif section.page_number == 22 || section.page_number == 23
        page_heading_margin_in_lines = 4
      else
        page_heading_margin_in_lines = publication.inner_page_heading_height
      end
    end
    h = {}
    h[:kind]                          = kind          unless h[:kind] == '기사'
    h[:reporter]                      = '홍길동'       if  h[:kind] == '기고'
    h[:column]                        = column
    h[:row]                           = row
    h[:grid_width]                    = grid_width
    h[:grid_height]                   = grid_height
    h[:gutter]                        = gutter
    h[:on_left_edge]                  = on_left_edge
    h[:on_right_edge]                 = on_right_edge
    h[:is_front_page]                 = is_front_page
    h[:top_story]                     = top_story
    h[:top_position]                  = top_position
    h[:bottom_article]                = section.bottom_article?(self)
    h[:page_heading_margin_in_lines]  = page_heading_margin_in_lines
    h[:article_bottom_spaces_in_lines]= publication.article_bottom_spaces_in_lines
    h[:article_line_draw_sides]       = publication.article_line_draw_sides
    h[:article_line_thickness]        = publication.article_line_thickness
    h[:draw_divider]                  = publication.draw_divider

    content=<<~EOF
    RLayout::NewsArticleBox.new(#{h})

    EOF
    if kind == '기고'
      content=<<~EOF
      RLayout::NewsArticleBox.new(#{h}) do
        news_image({:image_path=>"#{Rails.root}/public/1/opinion/홍길동.pdf", :column=>1, :row=>1, :extra_height_in_lines=>5, :stroke_width=>0, :position=>1, :is_float=>true, :fit_type=>4, :before_title=>true, :layout_expand=>nil})
      end
      EOF
    else
      content=<<~EOF
      RLayout::NewsArticleBox.new(#{h})
      EOF
    end
  end

  def save_layout
    File.open(layout_path, 'w'){|f| f.write layout_rb}
  end

  def save_story
    File.open(story_path, 'w'){|f| f.write story_md}
  end

  def read_story
    File.open(story_path, 'r'){|f| f.read }
  end

  def library_images
    publication.library_images
  end

  def page_columns
    section.column
  end

  def filler_text(empty_line_count, options={})
    with_reporter = options.fetch(:with_reporter, true)
    filler_text_path = publication.path + "/filler_text/#{page_columns}/#{empty_line_count}_lines_with_reporter.md"
    unless with_reporter
      filler_text_path = publication.path + "/filler_text/#{page_columns}/#{empty_line_count}_lines.md"
    end
    return File.open(filler_text_path, 'r'){|f| f.read} + "\n" if File.exist?(filler_text_path)
    return ""
  end

  def fill_up_enpty_lines
    #code
    article_info_hash = article_info
    unless article_info_hash
      puts "No article_info found in #{path}!!!!!"
      return
    end
    empty_lines = article_info_hash[:empty_lines]
    return if 0 > empty_lines
    if article_info_hash[:empty_lines] > 7
      multiples      = empty_lines/7
      remainder_lines = empty_lines%7
      text = body
      multiples.times do
        text += filler_text(7, with_reporter: false)
      end
      #remainder_lines
      text += filler_text(remainder_lines)
      self.body = text
    else
      self.body += filler_text(empty_lines)
    end
    self.save
    generate_pdf
  end

  def make_profile
    profile = "#{page_columns}단 편집_"
    if is_front_page
      profile += "1면_"
    else
      profile += "내지_"
    end
    if top_story
      profile += "메인기사"
    elsif top_position
      profile += "상단기사"
    else
      profile += "일반기사"
    end
    profile += "_#{column}x#{row}"

    profile
  end

end
