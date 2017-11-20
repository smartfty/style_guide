class HeadingBgImage < ApplicationRecord
  belongs_to :page_heading
  mount_uploader :heading_bg_image, HeadingBgImageUploader

  def publication
    page_heading.publication
  end

  def issue
    page_heading.issue
  end

  def image_path
    "#{Rails.root}/public" + heading_bg_image.url if heading_bg_image
  end

  def update_change
    page_heading.generate_pdf
    page_heading.update_page_pdf
  end
end
