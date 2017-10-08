# == Schema Information
#
# Table name: heading_ad_images
#
#  id               :integer          not null, primary key
#  heading_ad_image :string
#  x                :float
#  y                :float
#  width            :float
#  height           :float
#  x_in_unit        :float
#  y_in_unit        :float
#  width_in_unit    :float
#  height_in_unit   :float
#  page_heading_id  :integer
#  advertiser       :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class HeadingAdImage < ApplicationRecord
  belongs_to :page_heading
  mount_uploader :heading_ad_image, HeadingAdImageUploader

  def publication
    page_heading.publication
  end

  def issue
    page_heading.issue
  end

  def image_path
    "#{Rails.root}/public" + heading_ad_image.url if heading_ad_image
  end

  def update_change
    page_heading.generate_pdf
    page_heading.update_page_pdf
  end
end
