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

class Ad < ApplicationRecord
  belongs_to :publication
  belongs_to :issue
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

  def ad_width
    publication.width_of_grid_frame(page_columns, [0,0,column,row])
  end

  def ad_height
    publication.height_of_grid_frame(page_columns, [0,0,column,row])
  end

  def ad_top_margin
    publication.body_line_height
  end

  def layout_rb
    puts "saving ad layout_rb"
    puts "path:#{path}"
    content=<<~EOF
    RLayout::NewsAdBox.new(is_ad_box: true, width: #{ad_width}, height:#{ad_height}, top_margin: #{ad_top_margin}) do
      image(image_path: 'some_path', layout_expand: [:width, :height])
      relayout!
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
    # name
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

  def save_current_ads
    csv_path = "#{Rails.root}/public/1/ad/ads.csv"
    File.open(csv_path, 'w'){|f| f.write Ad.to_csv.to_s}
  end

end
