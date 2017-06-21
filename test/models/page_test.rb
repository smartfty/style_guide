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
#  template_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class PageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
