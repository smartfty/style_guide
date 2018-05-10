# == Schema Information
#
# Table name: heading_bg_images
#
#  id               :integer          not null, primary key
#  heading_bg_image :string
#  page_heading_id  :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_heading_bg_images_on_page_heading_id  (page_heading_id)
#

require 'test_helper'

class HeadingBgImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
