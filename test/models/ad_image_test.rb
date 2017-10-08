# == Schema Information
#
# Table name: ad_images
#
#  id             :integer          not null, primary key
#  ad_type        :string
#  column         :integer
#  row            :integer
#  ad_image       :string
#  advertiser     :string
#  page_number    :integer
#  article_number :integer
#  ad_box_id      :integer
#  issue_id       :integer
#  used_in_layout :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class AdImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
