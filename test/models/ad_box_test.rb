# == Schema Information
#
# Table name: ad_boxes
#
#  id         :integer          not null, primary key
#  column     :integer
#  row        :integer
#  ad_type    :string
#  advertiser :string
#  page_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AdBoxTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
