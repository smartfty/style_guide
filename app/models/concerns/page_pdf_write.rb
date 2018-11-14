require 'hexapdf'

module PagePdfWrite
  extend ActiveSupport::Concern
  def write_pdf(options={})

    pdf_doc = HexaPDF::Document.new
    page = pdf_doc.pages.add([0, 0, width, height])
    canvas = page.canvas
    if page_heading
      image_path = page_heading.pdf_path
      canvas.image(image_path, at: translated_origin(page_heading), width: page_heading.width, height: page_heading.height)
    end
    working_articles.each do |w|
      image_path = w.path + "/story.pdf"
      canvas.image(image_path, at: translated_origin(w), width: w.width, height: w.height)
    end

    ad_boxes.each do |ad|
      image_path = ad.pdf_path
      canvas.image(image_path, at: filipped_origin(ad), width: ad.width, height: ad.height)
    end
    pdf_path = path + "/page.pdf"
    pdf_doc.write(pdf_path, optimize: true)

  end

  def filipped_origin(w)
    [left_margin + w.grid_x*grid_width, height - (top_margin  + w.grid_y*grid_height + w.height)]
  end

end