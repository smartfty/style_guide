# == Schema Information
#
# Table name: image_templates
#
#  id              :integer          not null, primary key
#  column          :integer
#  row             :integer
#  height_in_lines :integer
#  image_path      :string
#  caption_title   :string
#  caption         :string
#  position        :integer
#  page_columns    :integer
#  article_id      :integer
#  publication_id  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ImageTemplate < ApplicationRecord
  belongs_to :publication
  validates :column, presence: true
  validates :row, presence: true
  after_create :setup

  scope :six_column, -> {where("page_columns==?", 6)}
  scope :seven_column, -> {where("page_columns==?", 7)}

  def path
    publication.path + "/image_template/#{page_columns}/#{column}x#{row}/"
  end

  def local_image_path
    "/images/#{File.basename(image_path)}"
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
    "/#{publication.id}/image_template/#{page_columns}/#{column}x#{row}/output.pdf"
  end

  def jpg_image_path
    "/#{publication.id}/image_template/#{page_columns}/#{column}x#{row}/output.jpg"
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    system "mkdir -p #{images_path}" unless File.directory?(images_path)
    # system "mkdir -p #{images_path}" unless File.directory?(images_path)
  end

  def image_size_in_grid
    "#{column}x#{row}"
  end

  def lines_per_grid
    publication.lines_per_grid
  end

  def image_area_in_lines
    column*row*lines_per_grid
  end

  def iamge_layout_hash
    h = {}
    h[:column]            = column
    h[:row]               = row
    h[:position]          = position
    h[:height_in_lines]   = height_in_lines
    h[:is_float]          = true
    h
  end

  def layout_path
    path + "/layout.rb"
  end

  def save_layout
    # system "cp -r #{source} #{path}/"
    system "cp #{image_path} #{images_path}/" unless File.exist?(images_path + File.basename(image_path))
    File.open(layout_path, 'w'){|f| f.write layout_rb}
  end

  def  to_svg
    #code
  end
  #
  # def layout_rb
  #   puts "column:#{column}"
  #   puts "publication.grid_width(column):#{publication.grid_width(column)}"
  #   grid_width  = publication.grid_width(column)
  #   puts "grid_width:#{grid_width}"
  #   grid_height = publication.grid_height
  #   gutter      = publication.gutter
  #   content=<<~EOF
  #   RLayout::NewsArticleBox.new(column: #{parent_column}, row:#{parent_row}, grid_width:#{publication.grid_width(column)}, grid_height:#{grid_height}, gutter:#{gutter} )
  #     image(#{iamge_layout_hash})
  #   EOF
  # end

  def generate_pdf
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
  end

  def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        # get rif of id, created_at, updated_at
        filtered = column_names.dup
        filtered.shift
        filtered.pop
        filtered.pop
        csv << filtered
        all.each do |item|
          csv << item.attributes.values_at(*filtered)
        end
      end
  end

end
