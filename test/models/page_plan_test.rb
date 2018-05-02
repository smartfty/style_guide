# == Schema Information
#
# Table name: page_plans
#
#  id                   :integer          not null, primary key
#  page_number          :integer
#  section_name         :string
#  selected_template_id :integer
#  column               :integer
#  row                  :integer
#  story_count          :integer
#  profile              :string
#  ad_type              :string
#  advertiser           :string
#  color_page           :boolean
#  dirty                :boolean
#  issue_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_page_plans_on_issue_id  (issue_id)
#

require 'test_helper'

class PagePlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
