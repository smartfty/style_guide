# == Schema Information
#
# Table name: ad_box_templates
#
#  id         :integer          not null, primary key
#  grid_x     :integer
#  grid_y     :integer
#  column     :integer
#  row        :integer
#  order      :integer
#  ad_type    :string
#  section_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AdBoxTemplate < ApplicationRecord
  belongs_to :section #, optional: true
  after_create :setup

  def path
    section.path + "/ad"
  end

  def images_path
    path + "/images"
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    system "mkdir -p #{images_path}" unless File.directory?(images_path)
  end

  def publication
    section.publication
  end

  def generate_pdf
    save_layout
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
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
    section.page_number == 1
  end

  def layout_rb
    grid_width    = publication.grid_width(section.column)
    grid_height   = publication.grid_height
    ad_width      = grid_width*column
    ad_heigth     = grid_height*row
    x             = publication.left_margin
    if section.page_number.odd?
      x = publication.width - publication.right_margin - ad_width
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


    content=<<~EOF

    RLayout::NewsAdBox.new(is_ad_box: true, column: #{column}, row: #{row}, grid_width: #{grid_width}, grid_height: #{grid_height}, page_heading_margin_in_lines: #{page_heading_margin_in_lines}) do
      image(image_path: 'some_image_path', layout_expand: [:width, :height])
      relayout!
    end
    EOF

  end

  def layout_path
    path + "/layout.rb"
  end

  def save_layout
    FileUtils.mkdir_p(path) unless File.exist?(path)
    File.open(layout_path, 'w'){|f| f.write layout_rb}
  end

end
