# == Schema Information
#
# Table name: working_articles
#
#  id             :integer          not null, primary key
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
#  page_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class WorkingArticle < ApplicationRecord
  belongs_to :page
  has_many :images
  has_one :ad_images
  before_create :parse_article
  accepts_nested_attributes_for :images

  def page_path
    page.path
  end

  def path
    page_path + "/#{order}"
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
    "/#{publication.id}/issue/#{page.issue.date.to_s}/#{page.page_number}/#{order}/output.pdf"
  end

  def jpg_image_path
    "/#{publication.id}/issue/#{page.issue.date.to_s}/#{page.page_number}/#{order}/output.jpg"
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


  def filtered_title
    RubyPants.new(title).to_html
  end

  def story_metadata
    h = {}
    h['title']      = RubyPants.new(title).to_html
    h['subtitle']   = RubyPants.new(subtitle).to_html
    h['reporter']   = reporter
    h['email']      = email
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
      if is_front_page
        # front_page_heading_height - lines_per_grid
        page_heading_margin_in_lines = publication.front_page_heading_margin
      else
        page_heading_margin_in_lines = publication.inner_page_heading_height
      end
    end

    h = {}
    h[:kind]                          = kind if kind
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
    h[:page_heading_margin_in_lines]  = page_heading_margin_in_lines
    h[:article_bottom_spaces_in_lines]= publication.article_bottom_spaces_in_lines
    h[:article_line_thickness]        = publication.article_line_thickness
    h[:article_line_draw_sides]       = publication.article_line_draw_sides
    h[:article_line_draw_sides]       = publication.draw_divider
    h
    h = h.to_s.gsub("{", "").gsub("}", "")
    content = "RLayout::NewsArticleBox.new(#{h}) do\n"
    if image_hash = image_options
      content += "  news_image(#{image_hash})\n"
    end
    content += "end\n"
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
