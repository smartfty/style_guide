# == Schema Information
#
# Table name: pages
#
#  id           :integer          not null, primary key
#  page_number  :integer
#  section_name :string
#  column       :integer
#  row          :integer
#  ad_type      :string
#  story_count  :integer
#  color_page   :boolean
#  profile      :string
#  issue_id     :integer
#  page_plan_id :integer
#  template_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  clone_name   :string
#  slug         :string
#
# Indexes
#
#  index_pages_on_issue_id      (issue_id)
#  index_pages_on_page_plan_id  (page_plan_id)
#  index_pages_on_slug          (slug) UNIQUE
#

require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test "create class" do
    assert true
  end

  test "change_template" do

    
  end
end
