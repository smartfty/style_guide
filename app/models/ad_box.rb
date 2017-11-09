# == Schema Information
#
# Table name: ad_boxes
#
#  id         :integer          not null, primary key
#  grid_x     :integer
#  grid_y     :integer
#  column     :integer
#  row        :integer
#  ad_type    :string
#  advertiser :string
#  page_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AdBox < ApplicationRecord
  belongs_to :page
  has_one  :ad_image
  accepts_nested_attributes_for :ad_image
  after_create :setup

  def path
    page.path + "/ad"
  end

  def setup
    FileUtils.mkdir_p path unless File.exist?(path)
  end

  def publication
    page.publication
  end

  def issue
    page.issue
  end

  def jpg_image_path
    page.url + "/ad/output.jpg"
  end

  def publication
    page.publication
  end

  def gutter
    publication.gutter
  end

  def grid_width
    publication.grid_width(page.column)
  end

  def grid_height
    publication.grid_height
  end

  def x
    grid_width*grid_x
  end

  def y
    grid_height*grid_y
  end

  def ad_height
    grid_height*row
  end

  def top_position?
    grid_y == 0 || (grid_y == 1 && page.page_number == 1)
  end

  def on_left_edge?
    grid_x == 0
  end

  def on_right_edge?
    grid_x + grid_width == page.column
  end

  def is_front_page?
    page.page_number == 1
  end

  def layout_rb
    x             = publication.left_margin
    left_inset    = 0
    right_inset   = 0
    ad_width      = grid_width*column
    if page.page_number.odd?
      x = publication.width - publication.right_margin - ad_width
      if column < page.column
        x += gutter/2
        ad_width -= gutter
        left_inset = gutter
      end
    else
      if column < page.column
        ad_width -= gutter
        right_inset = gutter
      end
    end
    page_heading_margin_in_lines = 0
    if top_position?
      if is_front_page?
        # front_page_heading_height - lines_per_grid
        page_heading_margin_in_lines = publication.front_page_heading_margin
      else
        page_heading_margin_in_lines = publication.inner_page_heading_height
      end
    end


    image_path                                     = ad_image.image_path if ad_image
    ad_image_hash = {}
    ad_image_hash[:image_path]                     = image_path
    ad_image_hash[:layout_expand]                  = [:width, :height]
    ad_image_hash[:page_heading_margin_in_lines]   = [:page_heading_margin_in_lines]

    content=<<~EOF
    RLayout::NewsAdBox.new(is_ad_box: true, width: #{ad_width}, left_inset: #{left_inset}, right_inset: #{right_inset}, height:#{ad_height}, top_margin: 13.849238095238096) do
      image(image_path: '#{image_path}', layout_expand: [:width, :height])
      relayout!
    end
    EOF
  end
  #
  # def layout_rb
  #   x             = publication.left_margin
  #   left_inset    = 0
  #   right_inset   = 0
  #   ad_width      = grid_width*column
  #   if page.page_number.odd?
  #     x = publication.width - publication.right_margin - ad_width
  #     if column < page.column
  #       x += gutter/2
  #       ad_width -= gutter
  #       left_inset = gutter
  #     end
  #   else
  #     if column < page.column
  #       ad_width -= gutter
  #       right_inset = gutter
  #     end
  #   end
  #
  #   page_heading_margin_in_lines = 0
  #   if top_position?
  #     if is_front_page?
  #       page_heading_margin_in_lines = publication.front_page_heading_margin
  #     else
  #       page_heading_margin_in_lines = publication.inner_page_heading_height
  #     end
  #   end
  #
  #   h = {}
  #   h[:column]                        = column
  #   h[:row]                           = row
  #   h[:grid_width]                    = grid_width
  #   h[:grid_height]                   = grid_height
  #   h[:gutter]                        = gutter
  #   h[:on_left_edge]                  = on_left_edge?
  #   if h[:on_left_edge].nil?
  #     h[:on_left_edge] = false
  #     h[:on_left_edge] = true if grid_x == 0
  #   end
  #   h[:on_right_edge]                 = on_right_edge?
  #   if h[:on_right_edge].nil?
  #     h[:on_right_edge] = false
  #     h[:on_right_edge] = true if h[:column] + grid_x == page.column
  #   end
  #   h[:is_front_page]                 = is_front_page?
  #   h[:top_story]                     = top_story
  #   h[:top_position]                  = top_position
  #   h[:page_heading_margin_in_lines]  = page_heading_margin_in_lines
  #   h[:article_bottom_spaces_in_lines]= publication.article_bottom_spaces_in_lines
  #   h[:article_line_thickness]        = publication.article_line_thickness
  #   h[:article_line_draw_sides]       = publication.article_line_draw_sides
  #   h[:draw_divider]                  = publication.draw_divider
  #   h
  #   # h = h.to_s.gsub("{", "").gsub("}", "")
  #   content = "RLayout::NewsAdBox.new(#{h}) do\n"
  #   image_hash[:fit_type]   = 4
  #   image_hash[:expand]     = [:width, :height]
  #   image_hash[:image_path] = ad_image.image_path if ad_image
  #   content += "  news_image(#{image_hash})\n"
  #   content += "end\n"
  #   content
  # end


  def layout_path
    path + "/layout.rb"
  end

  def save_layout
    puts __method__
    puts "layout_rb:#{layout_rb}"
    puts "layout_path:#{layout_path}"
    File.open(layout_path, 'w'){|f| f.write layout_rb}
    puts "File.exist?(layout_path):#{File.exist?(layout_path)}"
  end

  def generate_pdf
    save_layout
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
    update_page_pdf
  end

  def update_page_pdf
    page_path = page.path
    puts "page_path:#{page_path}"
    system "cd #{page_path} && /Applications/newsman.app/Contents/MacOS/newsman section ."
  end

  def box_svg
    "<a xlink:href='/ad_boxes/#{id}'><image xlink:href='#{jpg_image_path}' x='#{x}' y='#{y}' width='#{grid_width*column}' height='#{ad_height}' /></a>\n"
  end

end
