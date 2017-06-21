# == Schema Information
#
# Table name: ads
#
#  id             :integer          not null, primary key
#  name           :string
#  column         :integer
#  row            :integer
#  page_columns   :integer
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# t.string :name
# t.integer :column
# t.integer :row
# t.integer :page_columns
# t.integer :publication_id


class Ad < ApplicationRecord
  belongs_to :publication
  after_create :setup
  validates :column, presence: true
  validates :row, presence: true
  validates :page_columns, presence: true
  validates :publication_id, presence: true

  def path
    "#{Rails.root}/public/#{publication_id}/ad/#{page_columns}/#{name}"
  end

  def images_path
    path + "/images"
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    system "mkdir -p #{images_path}" unless File.directory?(images_path)
  end

  def generate_pdf
    save_layout
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
  end

  def layout_rb
    grid_width  = publication.grid_width(column)
    grid_height = publication.grid_height
    gutter      = publication.gutter
    content=<<~EOF
    RLayout::NewsArticleBox.new(column: #{column}, row:#{row}, grid_width: #{publication.grid_width(column)}, grid_height: #{grid_height}, gutter:#{gutter}, is_ad_box: true, grid_base: [#{column}, #{row}] ) do
      image(image_path: 'some_path', layout_expand: [:width, :height], grid_frame: [0,0, #{column}, #{row}], is_float: true)
      layout_floats!
    end
    EOF
  end

  def layout_path
    path + "/layout.rb"
  end

  def sample_ad_path
    "#{Rails.root}/public/#{publication_id}/ad/sample/#{name}"
  end

  def copy_sample_ad
    # copy random asmple ad
    name
    ad = Dir.glob("#{sample_ad_path}/*{.jpg,.pdf}").sample
    puts "sample_ad_path:#{sample_ad_path}"
    puts "ad:#{ad}"
    puts "cp #{ad} #{ad_folder}/images/1.jpg"
    if ad
      system "cp #{ad} #{path}/images/1.jpg"
    end
  end

  def save_layout
    File.open(layout_path, 'w'){|f| f.write layout_rb}
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
