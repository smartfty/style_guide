# == Schema Information
#
# Table name: publications
#
#  id                 :integer          not null, primary key
#  name               :string
#  paper_size         :string
#  width              :float
#  height             :float
#  left_margin        :float
#  top_margin         :float
#  right_margin       :float
#  bottom_margin      :float
#  lines_per_grid     :integer
#  divider            :float
#  gutter             :float
#  page_count         :integer
#  section_names      :text
#  page_columns :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Publication < ApplicationRecord
  has_many :text_styles
  has_many :articles
  has_many :image_templates
  after_create :setup

  def path
    "#{Rails.root}/public/#{id}"
  end

  def images_path
    "#{Rails.root}/public/images"
  end

  def library_images
    path_array = Dir.glob("#{images_path}/*[.jpg,.pdf]")
    front = "#{Rails.root}/public"
    path_array.map{|p| p.gsub!(front, "")}
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
  end

  def page_pdf_path
    path + "/layout"
  end

  def layout_rb(column, row)
    content=<<~EOF
    RLayout::NewspaperSectionPage.new(width:#{width}, height:#{height}, gutter:#{gutter} divider: #{divider}, :column:#{column}, row:#{row})
    EOF
  end

  def generate_pdf
    #code
  end

  def grid_width(page_columns)
    h = (width - left_margin - right_margin)/7
    if page_columns == 7
    elsif page_columns == 6
      h = (width - left_margin - right_margin)/6
    elsif page_columns == 5
      h = (width - left_margin - right_margin)/5
    end
    h
  end

  def grid_height
    (height - top_margin - bottom_margin)/15
  end

  def body_line_height
    grid_height/lines_per_grid
  end

  def x_of_grid_frame(page_columns, grid_frame)
    left_margin + grid_width(page_columns)*grid_frame[0]
  end

  def y_of_grid_frame(page_columns, grid_frame)
    grid_frame[1]*grid_height
  end


  def width_of_grid_frame(page_columns, grid_frame)
    grid_width(page_columns)*grid_frame[2]
  end

  def height_of_grid_frame(page_columns, grid_frame)
    grid_frame[3]*grid_height
  end

  def frame_rect_of_grid_frame(page_columns, grid_frame)
    [x_of_grid_frame(grid_frame), y_of_grid_frame(grid_frame), width_of_grid_frame(grid_frame), height_of_grid_frame(grid_frame)]
  end

  def page_heading_width
    width - left_margin - right_margin
  end

  def page_heading_height_in_lines
    3
  end

  def page_heading_height
    page_heading_height_in_lines*body_line_height
  end

  def first_page_heading_height_in_lines
    8
  end

  def first_page_heading_height
    first_page_heading_height_in_lines*body_line_height
  end

  def divider_info(column)
    if column == 7
      [4, divider]
    elsif column == 6
      [3, divider]
    elsif column == 5
      [2, divider]
    end
  end

  def section_names_path
    #code
  end

  def reload_section_names
    section_names_path = path + "/section_names.rb"
    self.section_names = File.open(section_names_path, 'r'){|f| f.read}
    self.save
  end

end
