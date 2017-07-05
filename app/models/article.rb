# == Schema Information
#
# Table name: articles
#
#  id             :integer          not null, primary key
#  column         :integer
#  row            :integer
#  order          :integer
#  profile        :integer
#  title          :string
#  subtitle       :string
#  body           :text
#  reporter       :string
#  email          :string
#  personal_image :string
#  image          :string
#  quote          :string
#  subject_head       :string
#  is_front_page  :boolean
#  top_story      :boolean
#  top_position   :boolean
#  page_columns   :integer
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Article < ApplicationRecord
  belongs_to :section #, optional: true

  after_create :setup
  # scope :one_column, -> {where("column==?", 1)}
  # scope :two_column, -> {where("column==?", 2)}
  # scope :three_column, -> {where("column==?", 3)}
  # scope :four_column, -> {where("column==?", 4)}
  # scope :five_column, -> {where("column==?", 5)}
  # scope :six_column, -> {where("column==?", 6)}
  # scope :seven_column, -> {where("column==?", 7)}
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
    path + "/output.pdf"
  end

  def jpg_path
    path + "/output.jpg"
  end

  def relative_path
    section.relative_path + "/#{order}"
  end

  def pdf_image_path
    relative_path + "/output.pdf"
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

    quote           = "이부분이 이용한 부분입니다. 이부분은 본문 중간에 위치 하게 됩니다. 아마도 이부분이 좀던 눈에 띠게 해야 합나다."
    extra_paragraph = "\n#{quote}"*3

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

  def image_options
    #code
    if images.first
      images.first.iamge_layout_hash
    else
      nil
    end
  end

  def layout_rb
    grid_width    = publication.grid_width(page_columns)
    grid_height   = publication.grid_height
    gutter        = publication.gutter
    image_options = image_options if image_options

    content=<<~EOF
    RLayout::NewsArticleBox.new(column: #{column}, row:#{row}, on_left_edge: #{on_left_edge}, on_right_edge: #{on_right_edge}, is_front_page:#{is_front_page}, top_story:#{top_story}, top_position:#{top_position}, grid_width:#{grid_width}, grid_height:#{grid_height}, gutter:#{gutter} )
    EOF
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
