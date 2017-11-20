# == Schema Information
#
# Table name: page_headings
#
#  id           :integer          not null, primary key
#  page_number  :integer
#  section_name :string
#  date         :string
#  layout       :text
#  page_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class PageHeading < ApplicationRecord
  belongs_to :page
  has_many :heading_ad_images
  after_create :setup
  has_one :heading_bg_image
  accepts_nested_attributes_for :heading_bg_image

  SECTIONS = [
    '1면',
    '정치',
    '정치',
    '정치',
    '행정',
    '행정',
    '전면광고',
    '국제통일',
    '전면광고',
    '금융',
    '전면광고',
    '금융',
    '금융',
    '산업',
    '산업',
    '산업',
    '산업',
    '정책',
    '정책',
    '기획',
    '기획',
    '오피니언',
    '오피니언',
    '전면광고'
  ]

  def path
    p = page.path
    p += "/heading"
  end

  def issue
    page.issue
  end

  def publication
    issue.publication
  end

  def relative_path
    page.relative_path + "/heading"
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

  def self.layout_path(page)
    page.path + "/heading/layout.rb"
  end

  def pdf_path
    path + "/output.pdf"
  end

  def background_pdf_path
    path + "/images/1.pdf"
  end

  def jpg_path
    path + "/output.jpg"
  end

  def pdf_image_path
    relative_path + "/output.pdf"
  end

  def jpg_image_path
    relative_path + "/output.jpg"
  end

  def setup
    system("mkdir -p #{path}") unless File.directory?(path)
  end

  def page_heading_width
    publication.page_heading_width
  end

  def heading_height
    if page_number == 1
      publication.front_page_heading_height_in_pt
    else
      publication.inner_page_heading_height_in_pt
    end
  end

  def box_svg
    "<a xlink:href='/page_headings/#{id}'><rect fill-opacity='0.0' x='#{0}' y='#{0}' width='#{page_heading_width}' height='#{heading_height}' /></a>\n"
  end

  def front_page_content
    page_heading_width  = publication.page_heading_width
    heading_ad_image_path = heading_ad_images.first.image_path if heading_ad_images.first
    first_page=<<~EOF
    RLayout::Container.new(width: #{page_heading_width}, height: #{publication.front_page_heading_height_in_pt}, layout_direction: 'horinoztal') do
      image(local_image: '1.pdf', width: #{page_heading_width}, height: 110)
      text('2017년 5월 11일 목요일 (4200호)', x: 886.00, y: #{114.7549 - 20.0}, width: 200, height: 12, font: 'YDVYGOStd12', font_size: 9.5, text_alignment: 'left')
      image(image_path: ''#{heading_ad_image_path}', x:500, y:30, width: #{200}, height: 100)
    end
    EOF
  end

  def self.front_page_content
    publication = Publication.first
    page_heading_width  = publication.page_heading_width
    # heading_ad_image_path = heading_ad_images.first.image_path if heading_ad_images.first
    first_page=<<~EOF
    RLayout::Container.new(width: #{page_heading_width}, height: #{publication.front_page_heading_height_in_pt}, layout_direction: 'horinoztal') do
      image(local_image: '1.pdf', width: #{page_heading_width}, height: 110)
      text('2017년 5월 11일 목요일 (4200호)', x: 886.00, y: #{114.7549 - 20.0}, width: 200, height: 12, font: 'YDVYGOStd12', font_size: 9.5, text_alignment: 'left')
      image(image_path: ''heading_ad_image_path', x:500, y:30, width: #{200}, height: 100)
    end
    EOF
  end

  def even_content
    page_heading_width  = publication.page_heading_width
    page_heading_height = publication.inner_page_heading_height_in_pt
    date                = '2017년 5월 11일 목요일'
    even=<<~EOF
    RLayout::Container.new(width: #{page_heading_width}, height: #{page_heading_height}, layout_direction: 'horinoztal') do
      text('#{section_name}', x: 464.0 , y: 1, width: 100, font: 'YDVYMjOStd14',  font_size: 20, text_color: "#221E1F", text_alignment: 'center')
      text('#{page_number}', x: 1.9795, y: 1, font: 'YDVYGOStd14', font_size: 24, text_color: "#221E1F", width: 50, height: 44)
      text(#{date}, x: 33.5356, y: 10,  width: 200, font: 'YDVYGOStd12', font_size: 9.5, text_color: "#221E1F", text_alignment: 'left')
      image(image_path: '/Users/Shared/SoftwareLab/news_heading/logo/내일신문.pdf', x: #{page_heading_width - 48}, y: 10, width: 43, height: 12,)
      line(x: -3, width: 1037.81, y: 23.803, stroke_width: 0.3, stroke_color: "#221E1F")
      line(x: -3, width: 1037.81, y: 25.903, stroke_width: 0.3, stroke_color: "#221E1F")
    end
    EOF
  end

  def self.even_content(page)
    puts "page.class:#{page.class}"

    publication = Publication.first
    page_heading_width  = publication.page_heading_width
    page_heading_height = publication.inner_page_heading_height_in_pt
    date                = '2017년 5월 11일 목요일'
    page_number         = page.page_number
    section_name        = SECTIONS[page_number - 1]
    even=<<~EOF
    RLayout::Container.new(width: #{page_heading_width}, height: #{page_heading_height}, layout_direction: 'horinoztal') do
      text('#{section_name}', x: 464.0 , y: 1, width: 100, font: 'YDVYMjOStd14',  font_size: 20, text_color: "#221E1F", text_alignment: 'center')
      text('#{page_number}', x: 1.9795, y: 1, font: 'YDVYGOStd14', font_size: 24, text_color: "#221E1F", width: 50, height: 44)
      text(#{date}, x: 33.5356, y: 10,  width: 200, font: 'YDVYGOStd12', font_size: 9.5, text_color: "#221E1F", text_alignment: 'left')
      image(image_path: '/Users/Shared/SoftwareLab/news_heading/logo/내일신문.pdf', x: #{page_heading_width - 48}, y: 10, width: 43, height: 12,)
      line(x: -3, width: 1037.81, y: 23.803, stroke_width: 0.3, stroke_color: "#221E1F")
      line(x: -3, width: 1037.81, y: 25.903, stroke_width: 0.3, stroke_color: "#221E1F")
    end
    EOF
  end

  def odd_content
    page_heading_width  = publication.page_heading_width
    page_heading_height = publication.inner_page_heading_height_in_pt
    date                = '2017년 5월 11일 목요일'
    odd=<<~EOF
    RLayout::Container.new(width: #{page_heading_width}, height: #{page_heading_height}, layout_direction: 'horinoztal') do
      text('#{section_name}', x: 464.0, y: 1, width: 100, font: 'YDVYMjOStd14',  font_size: 20, text_color: "#221E1F", text_alignment: 'center')
      text('#{date}', x: 880.5693, y: 10,  width: 200, font: 'YDVYGOStd12', font_size: 9.5, text_color: "#221E1F", text_alignment: 'left')
      text('#{page_number}', x: 985, y: 1, font: 'YDVYGOStd14', font_size: 24, text_color: "#221E1F", width: 35, height: 44, text_alignment: 'right')
      image(image_path: '/Users/Shared/SoftwareLab/news_heading/logo/내일신문.pdf', x: 3, y: 10, width: 43, height: 12, fit_type: 0)
      line(x: -3, width: 1037.81, y: 23.803, stroke_width: 0.3, stroke_color: "#221E1F")
      line(x: -3, width: 1037.81, y: 25.903, stroke_width: 0.3, stroke_color: "#221E1F")
    end
    EOF
  end

  def self.odd_content(page)
    puts "page.class:#{page.class}"
    publication = Publication.first
    page_heading_width  = publication.page_heading_width
    page_heading_height = publication.inner_page_heading_height_in_pt
    date                = '2017년 5월 11일 목요일'
    page_number         = page.page_number
    section_name        = SECTIONS[page_number - 1]

    odd=<<~EOF
    RLayout::Container.new(width: #{page_heading_width}, height: #{page_heading_height}, layout_direction: 'horinoztal') do
      text('#{section_name}', x: 464.0, y: 1, width: 100, font: 'YDVYMjOStd14',  font_size: 20, text_color: "#221E1F", text_alignment: 'center')
      text('#{date}', x: 880, y: 10,  width: 200, font: 'YDVYGOStd12', font_size: 9.5, text_color: "#221E1F", text_alignment: 'left')
      text('#{page_number}', x: 985, y: 1, font: 'YDVYGOStd14', font_size: 24, text_color: "#221E1F", width: 35, height: 44, text_alignment: 'right')
      image(image_path: '/Users/Shared/SoftwareLab/news_heading/logo/내일신문.pdf', x: 3, y: 10, width: 43, height: 12, fit_type: 0)
      line(x: -3, width: 1037.81, y: 23.803, stroke_width: 0.3, stroke_color: "#221E1F")
      line(x: -3, width: 1037.81, y: 25.903, stroke_width: 0.3, stroke_color: "#221E1F")
    end
    EOF
  end

  def layout_content
    if page_number == 1
      return front_page_content
    elsif page_number.even?
      return even_content
    else
      return odd_content
    end
  end

  def self.layout_content(page)
    if page.page_number == 1
      return self.front_page_content
    elsif page.page_number.even?
      return self.even_content(page)
    else
      return self.odd_content(page)
    end
  end

  def save_layout
    File.open(layout_path, 'w'){|f| f.write layout_content}
  end

  def self.save_layout(page)
    File.open(self.layout_path(page), 'w'){|f| f.write layout_content(page)}
  end

  def generate_pdf
    save_layout
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
  end

  def self.generate_pdf(page)
    PageHeading.save_layout(page)
    path = page.page_heading_path
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
  end

end
