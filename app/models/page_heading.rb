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
    publicatio.page_heading_width
  end

  def first_page_heading_height
    publicatio.first_page_heading_height
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
    RLayout::Container.new(width: #{page_heading_width}, height: #{page_heading_height}, layout_direction: 'horinoztal', stroke_sizes: [0,0,0,1], stroke_width: 0.3) do
      text('#{page_number}', font: 'Helvetica', text_size: 32, width: 50, height: 44)
      container(layout_expand: :width, layout_direction: 'horinoztal', layout_length: 20, layout_align: 'justified') do
        text('#{date}', width: 200, text_size: 18, text_alignment: 'left')
        text('#{section_name}', width: 200, text_size: 24)
        text('내일신문', width: 230, text_alignment: 'right', text_size: 18,)
      end
      relayout!
    end
    EOF
  end

  def odd_content
    odd=<<~EOF
    RLayout::Container.new(width: #{page_heading_width}, height: #{page_heading_height}, layout_direction: 'horinoztal', stroke_sizes: [0,0,0,1], stroke_width: 0.3) do
      container(layout_expand: :width, layout_direction: 'horinoztal', layout_length: 20, layout_align: 'justified') do
        text('내일신문', width: 230, text_alignment: 'left', text_size: 18,)
        text('#{section_name}', width: 200, text_size: 24)
        text('#{date}', width: 200, text_size: 18, text_alignment: 'right')
      end
      text('#{page_number}', font: 'Helvetica', text_size: 32, width: 50, height: 44, text_alignment: 'right')
      relayout!
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

  def generate_pdf
    save_layout
    system "cd #{path} && /Applications/rjob.app/Contents/MacOS/rjob ."
  end
end
