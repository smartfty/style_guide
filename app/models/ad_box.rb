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
#  inactive   :boolean
#  page_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ad_boxes_on_page_id  (page_id)
#

class AdBox < ApplicationRecord
  belongs_to :page
  mount_uploader :ad_image, AdImageUploader
  after_create :setup

  def path
    page.path + "/ad"
  end

  def setup
    FileUtils.mkdir_p path unless File.exist?(path)
  end

  def issue
    page.issue
  end

  def pdf_image_path
    page.url + "/ad/output.pdf"
  end

  def jpg_image_path
    page.url + "/ad/output.jpg"
  end

  def publication
    if page
      page.publication
    else
      #TODO
      Publication.first
    end
  end

  def page_number
    page.page_number
  end

  def gutter
    publication.gutter
  end

  def order
    page.ad_boxes.index(self)
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
    grid_x + column == page.column
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

    image_path                                     = ad_image.path if ad_image
    ad_image_hash = {}
    ad_image_hash[:layout_expand]                  = [:width, :height]
    ad_image_hash[:page_heading_margin_in_lines]   = page_heading_margin_in_lines
    content=<<~EOF
    RLayout::NewsAdBox.new(is_ad_box: true, column: #{column}, row: #{row}, grid_width: #{grid_width}, grid_height: #{grid_height}, on_left_edge: #{on_left_edge?}, top_position: #{top_position?}, on_right_edge: #{on_right_edge?}, page_heading_margin_in_lines: #{page_heading_margin_in_lines}) do
      image(image_path: '#{image_path}', fit_type: 4, layout_expand: [:width, :height])
      relayout!
    end
    EOF
  end

  def layout_path
    path + "/layout.rb"
  end

  def save_layout
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
    "<a xlink:href='/ad_boxes/#{id}'><rect fill-opacity='0.0' x='#{x}' y='#{y}' width='#{grid_width*column}' height='#{ad_height}' /></a>\n"
  end

end
