# == Schema Information
#
# Table name: working_articles
#
#  id             :integer          not null, primary key
#  column         :integer
#  row            :integer
#  order          :integer
#  profile        :string
#  title          :text
#  subtitle       :text
#  body           :text
#  reporter       :string
#  email          :string
#  personal_image :string
#  image          :string
#  quote          :text
#  subject_head   :string
#  is_front_page  :boolean
#  top_story      :boolean
#  top_position   :boolean
#  page_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class WorkingArticle < ApplicationRecord
  belongs_to :page
  has_many :images
  before_create :parse_article

  def path
    page.path + "/#{order}"
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

  def pdf_image_path
    "/#{publication.id}/issue/#{page.issue.id}/#{page.page_number}/#{order}/output.pdf"
  end

  def jpg_image_path
    "/#{publication.id}/issue/#{page.issue.id}/#{page.page_number}/#{order}/output.jpg"
  end

  def article_info_path
    path + "/article_info.yml"
  end

  def save_article
    save_story
    save_layout
  end

  def update_pdf
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
  end

  def generate_pdf
    save_story
    save_layout
    # system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article . -custom=#{publication.name}"

  end

  def update_page_pdf
    page_path = page.path
    puts "page_path:#{page_path}"
    system "cd #{page_path} && /Applications/newsman.app/Contents/MacOS/newsman section_pdf ."

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

  def publication
    page.issue.publication
  end

  def image_options
    #code
    if images.first
      images.first.iamge_layout_hash
    else
      nil
    end
  end

  def page_columns
    page.column
  end

  def layout_rb
    grid_width    = publication.grid_width(page_columns)
    grid_height   = publication.grid_height
    gutter        = publication.gutter
    # content=<<~EOF
    # RLayout::NewsArticleBox.new(column: #{column}, row:#{row}, is_front_page:#{is_front_page}, top_story:#{top_story}, top_position:#{top_position}, grid_width:#{grid_width}, grid_height:#{grid_height}, gutter:#{gutter} )
    # EOF
    content = "RLayout::NewsArticleBox.new(column: #{column}, row:#{row}, is_front_page:#{is_front_page}, top_story:#{top_story}, top_position:#{top_position}, grid_width:#{grid_width}, grid_height:#{grid_height}, gutter:#{gutter}) do\n"
    if image_hash = image_options
      content += "  news_image(#{image_hash})\n"
    end
    puts "image_hash:#{image_hash}"
    content += "end\n"
    content
  end
  #
  # def layout_rb
  #   grid_width  = publication.grid_width(page.column)
  #   grid_height = publication.grid_height
  #   gutter      = publication.gutter
  #   content=<<~EOF
  #   RLayout::NewsArticleBox.new(column: #{column}, row:#{row}, is_front_page:#{is_front_page}, top_story:#{top_story}, top_position:#{top_position}, grid_width:#{grid_width}, grid_height:#{grid_height}, gutter:#{gutter} )
  #   EOF
  # end

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

  private

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
    self.title          = @metadata['title']
    self.subtitle       = @metadata['subtitle']
    self.body           = @contents
    self.reporter       = @metadata['reporter']
    self.email          = @metadata['email']
    self.personal_image = @metadata['personal_image']
    self.image          = @metadata['image']
    self.quote          = @metadata['quote']
    self.subject_head       = @metadata['subject_head']
  end

  def parse_article_info
    if article_info_hash = article_info
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

end
