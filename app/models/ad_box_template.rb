class AdBoxTemplate < ApplicationRecord
  belongs_to :section #, optional: true
  after_create :setup

  def path
    section.path + "/ad"
  end

  def images_path
    path + "/images"
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    system "mkdir -p #{images_path}" unless File.directory?(images_path)
  end

  def publication
    section.publication
  end

  def generate_pdf
    save_layout
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
  end

  def layout_rb
    grid_width    = publication.grid_width(section.column)
    grid_height   = publication.grid_height
    ad_width      = grid_width*column
    ad_heigth     = grid_height*row
    x             = publication.left_margin
    if section.page_number.odd?
      x = publication.width - publication.right_margin - ad_width
    end

    content=<<~EOF
    RLayout::NewsAdBox.new(is_ad_box: true, width: #{ad_width}, height:#{ad_heigth}, top_margin: 13.849238095238096) do
      image(image_path: 'some_path', layout_expand: [:width, :height])
      relayout!
    end
    EOF

  end

  def layout_path
    path + "/layout.rb"
  end

  def save_layout
    File.open(layout_path, 'w'){|f| f.write layout_rb}
  end

end
