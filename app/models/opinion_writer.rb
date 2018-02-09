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

  def path
    "#{Rails.root}/public/#{publication.id}/opinion"
  end

  def pdf_path
    path + "/#{name}.pdf"
  end

  def layout_path
    path + "/#{name}.pdf"
  end

  def csv_path
    "#{Rails.root}/public/#{publication.id}/opinion/#{opinion.csv}"
  end

  def layout_rb
    content =<<~EOF
    Container.new(width: #{publication.grid_width(6)}, height: #{publication.grid_height}) do
      line(0,0,100,0)
      text(#{title})
      text(#{work})
      text(#{position})
    end
    EOF
  end

  def save_layout
    File.open(layout_path, 'w'){|f| f.write layout_rb}
  end

  def generate_pdf
    system "cd #{path} && /Applications/namecard.app/Contents/MacOS/namecard"
  end
end
