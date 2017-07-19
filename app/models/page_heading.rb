# == Schema Information
#
# Table name: page_headings
#
#  id             :integer          not null, primary key
#  page_number    :integer
#  section_name   :string
#  date           :string
#  layout         :text
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PageHeading < ApplicationRecord
  belongs_to :publication

  after_create :setup

  def path
    "#{Rails.root}/public/#{publication.id}/page_heading/#{id}"
  end

  def from_public_path
    "#/#{publication.id}/page_heading/#{id}"
  end

  def setup
    system("mkidr -p #{path}") unless File.directory?(path)
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
    "/#{publication.id}/page_heading/#{page_number}/output.pdf"
  end

  def jpg_image_path
    "/#{publication.id}/page_heading/#{page_number}/output.jpg"
  end

  def setup
    system("mkdir -p #{path}") unless File.directory?(path)
  end

  def page_heading_width
    publication.page_heading_width
  end

  def first_page_heading_height
    publication.first_page_heading_height
  end

  def first_page_content
    first_page=<<~EOF
    RLayout::Container.new(width: #{page_heading_width}, height: #{first_page_heading_height}, layout_direction: 'horinoztal') do
      text('#{page_number}')
      text('#{date}')
      text('First Page Logo goes here!!')
      text('내일신문')
      relayout!
    end
    EOF
  end

  def page_heading_height
    publication.page_heading_height
  end

  def even_content
    even=<<~EOF

    RLayout::Container.new(width: 1028.98, height: 54.425, layout_direction: 'horinoztal') do
      text('#{section_name}', x: 464.0 , y: 1, width: 100, font: 'YDVYMjOStd14',  font_size: 20, text_color: "#221E1F", text_alignment: 'center')
      text('#{page_number}', x: 1.9795, y: 1, font: 'YDVYGOStd14', font_size: 24, text_color: "#221E1F", width: 50, height: 44)
      text('2017년 5월 11일 목요일', x: 33.5356, y: 10,  width: 200, font: 'YDVYGOStd12', font_size: 9.5, text_color: "#221E1F", text_alignment: 'left')
      image(image_path: '/Users/Shared/SoftwareLab/news_heading/logo/내일신문.pdf', x: #{page_heading_width - 48}, y: 10, width: 43, height: 12,)
      line(x: -3, width: 1037.81, y: 23.803, stroke_width: 0.3, stroke_color: "#221E1F")
      line(x: -3, width: 1037.81, y: 25.903, stroke_width: 0.3, stroke_color: "#221E1F")

    end
    EOF
  end

  def odd_content
    odd=<<~EOF
    RLayout::Container.new(width: 1028.98, height: 54.425, layout_direction: 'horinoztal') do
      text('#{section_name}', x: 464.0, y: 1, width: 100, font: 'YDVYMjOStd14',  font_size: 20, text_color: "#221E1F", text_alignment: 'center')
      text('2017년 5월 11일 목요일', x: 900.5693, y: 10,  width: 200, font: 'YDVYGOStd12', font_size: 9.5, text_color: "#221E1F", text_alignment: 'left')
      text('#{page_number}', x: 998, y: 1, font: 'YDVYGOStd14', font_size: 24, text_color: "#221E1F", width: 50, height: 44)
      image(image_path: '/Users/Shared/SoftwareLab/news_heading/logo/내일신문.pdf', x: 3, y: 10, width: 43, height: 12, fit_type: 0)
      line(x: -3, width: 1037.81, y: 23.803, stroke_width: 0.3, stroke_color: "#221E1F")
      line(x: -3, width: 1037.81, y: 25.903, stroke_width: 0.3, stroke_color: "#221E1F")
    end
    EOF
  end

  def layout_content
    if page_number == 1
      return first_page_content
    elsif page_number.even?
      return even_content
    else
      return odd_content
    end
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

  def save_layout
    File.open(layout_path, 'w'){|f| f.write layout_content}
  end

  def self.generate_pdf
    PageHeading.all.each do |ph|
      ph.generate_pdf
    end
  end

  def generate_pdf
    save_layout
    # system "cd #{path} && /Applications/rjob.app/Contents/MacOS/rjob ."
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
  end


  def save_layout_for_page(page)
    path_layout_path = page.page_headig_path
    File.open(layout_path, 'w'){|f| f.write layout_content}
  end


  def generate_pdf_for_page(page)
    save_layout_for_page(page)
    page_path = page.path
    system "cd #{page_path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
    #code
  end
end
