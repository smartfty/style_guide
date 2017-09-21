# == Schema Information
#
# Table name: ad_images
#
#  id                 :integer          not null, primary key
#  ad_type            :string
#  column             :integer
#  row                :integer
#  image_path         :string
#  advertiser         :string
#  page_number        :integer
#  article_number     :integer
#  working_article_id :integer
#  issue_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class AdImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
