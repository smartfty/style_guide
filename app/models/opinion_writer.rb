# == Schema Information
#
# Table name: opinion_writers
#
#  id             :integer          not null, primary key
#  name           :string
#  title          :string
#  work           :string
#  position       :string
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class OpinionWriter < ApplicationRecord
  belongs_to :publication
  mount_uploader :OpionImage, OpionImageUploader

  def path
    "#{Rails.root}/public/#{publication.id}/opinion"
  end

  def pdf_path
    path + "/#{name}.pdf"
  end

  def pdf_image_path
    "/#{publication.id}/opinion/#{name}.pdf"
  end

  def jpg_image_path
    "/#{publication.id}/opinion/#{name}.jpg"
  end

  def layout_path
    path + "/#{name}.rb"
  end

  def csv_path
    "#{Rails.root}/public/#{publication.id}/opinion/#{opinion.csv}"
  end


  def layout_erb
    layout =<<~EOF
    RLayout::Container.new(width:171.496083,  height: 165.219) do
      line(x: 0 , y:1, width: 171.496083, stroke_width: 2, height:0)
      text('<%= title %>', y:5, font: 'KoPubDotumPB', font_size: 12, width: 170)
      rect(x: 0, y: 70, width:171.496083, height: 65,  fill_color:"CMYK=0,0,0,10")
      <% if name.include?("_") %>
        <% name_without_rest = name.split("_").first %>
        image(local_image: '<%= name_without_rest %>.eps', y: 60, width: 60, height: 75, fill_color: 'clear')
      <% else %>
        image(local_image: '<%= name %>.eps', y: 60, width: 60, height: 75, fill_color: 'clear')
      <% end %>
      container(x: 70, y: 80, width:150, bottom_margin: 10, fill_color: 'clear') do
        <% if name && name.include?("_") %>
          text('<%= work %>', y:30, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
          text('<%= position %>', y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
        <% elsif name && work && position %>
          <% if name.include?("-") %>
            text('<%= name.split("-").first.gsub("+", " ") %>', y:17, font: 'KoPubDotumPB', font_size: 9, fill_color: 'clear')
          <% else  %>
            text('<%= name.gsub("+", " ") %>', y:17, font: 'KoPubDotumPB', font_size: 9, fill_color: 'clear')
          <% end  %>
          text('<%= work %>', y:30, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
          text('<%= position %>', y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
        <% elsif position == nil %>
          text('<%= name.gsub("+", " ") %>', y:28, font: 'KoPubDotumPB', font_size: 9, fill_color: 'clear')
          text('<%= work %>', y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
        <% end %>
      end
    end
    EOF
  end

  def save_layout
    erb = ERB.new(layout_erb)
    layout_rb = erb.result(binding)
    puts layout_rb
    File.open(layout_path, 'w'){|f| f.write layout_rb}
  end

  def generate_pdf
    save_layout
    system "cd #{path} && /Applications/rjob.app/Contents/MacOS/rjob #{name}.rb"
  end
end
