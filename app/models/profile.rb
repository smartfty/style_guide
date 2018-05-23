# == Schema Information
#
# Table name: profiles
#
#  id             :integer          not null, primary key
#  name           :string
#  profile_image  :string
#  work           :string
#  position       :string
#  email          :string
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  title          :string
#  category_code  :integer
#
# Indexes
#
#  index_profiles_on_publication_id  (publication_id)
#
# Foreign Keys
#
#  fk_rails_...  (publication_id => publications.id)
#

class Profile < ApplicationRecord
  belongs_to :publication
  mount_uploader :profile_image, ProfileImageUploader

  def path
    "#{Rails.root}/public/#{publication.id}/profile"
  end

  def pdf_path
    path + "/#{name}.pdf"
  end

  def pdf_image_path
    "/#{publication.id}/profile/#{name}.pdf"
  end

  def jpg_image_path
    "/#{publication.id}/profile/#{name}.jpg"
  end

  def layout_path
    path + "/#{name}.rb"
  end

  def csv_path
    "#{Rails.root}/public/#{publication.id}/profile/#{profile.csv}"
  end


  def layout_erb
    layout =<<~EOF
    RLayout::Container.new(width:158.737,  height: 75) do
      rect(x: 0, y: 10, width:158.737, height: 65, fill_color:"CMYK=0,0,0,10")
      image(local_image: '<%= name %>.eps', from_right: 0, y: 0, width: 60, height: 75, fill_color: 'clear')
      container(x: 0, y: 20, width:100, bottom_margin: 10, fill_color: 'clear') do
        <% if name && work && work != "" && position && position != "" %>
          <% if name.include?('-') %>
          text('<%= name.split("-").first.gsub("+", " ") %>', text_alignment: 'right', from_right: 10, y:17, font: 'KoPubDotumPB', font_size: 9, font_color:"CMYK=0,0,0,10", fill_color: 'clear')
          <% else  %>
          text('<%= name.gsub("+", " ") %>', text_alignment: 'right', from_right: 10, y:17, font: 'KoPubDotumPB', font_size: 9,font_color:"CMYK=0,0,0,10", fill_color: 'clear')
          <% end  %>
          text('<%= work %>', text_alignment: 'right', from_right: 10, y:30, font: 'KoPubDotumPL', font_size: 8, font_color:"CMYK=0,0,0,10", fill_color: 'clear')
          text('<%= position %>', text_alignment: 'right', from_right: 10, y:41, font: 'KoPubDotumPL', font_size: 8, font_color:"CMYK=0,0,0,10", fill_color: 'clear')
        <% elsif position == "" || position == nil %>
          text('<%= name.gsub("+", " ") %>', text_alignment: 'right', from_right: 10, y:28, font: 'KoPubDotumPB', font_size: 9, font_color:"CMYK=0,0,0,10", fill_color: 'clear')
          text('<%= work %>', text_alignment: 'right', from_right: 10, y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
        <% elsif work == "" || work == nil %>
          text('<%= name.gsub("+", " ") %>', text_alignment: 'right', from_right: 10, y:28, font: 'KoPubDotumPB', font_size: 9, font_color:"CMYK=0,0,0,10", fill_color: 'clear')
          text('<%= position %>', text_alignment: 'right', from_right: 10, y:41, font: 'KoPubDotumPL', font_size: 8, font_color:"CMYK=0,0,0,10", fill_color: 'clear')
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
    system "cd #{path} && /Applications/rjob.app/Contents/MacOS/rjob #{name}.rb -jpg"
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
