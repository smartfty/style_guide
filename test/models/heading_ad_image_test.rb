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
# Indexes
#
#  index_heading_ad_images_on_page_heading_id  (page_heading_id)
#

require 'test_helper'

class HeadingAdImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
