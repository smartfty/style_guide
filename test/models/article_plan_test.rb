# == Schema Information
#
# Table name: article_plans
#
#  id           :integer          not null, primary key
#  page_plan_id :integer
#  reporter     :string
#  order        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ArticlePlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
