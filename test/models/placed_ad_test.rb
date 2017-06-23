# == Schema Information
#
# Table name: placed_ads
#
#  id         :integer          not null, primary key
#  ad_type    :string
#  column     :integer
#  row        :integer
#  advertiser :string
#  order      :integer
#  page_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PlacedAdTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
