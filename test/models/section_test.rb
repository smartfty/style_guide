# == Schema Information
#
# Table name: sections
#
#  id             :integer          not null, primary key
#  profile        :string
#  column         :integer
#  row            :integer
#  order          :integer
#  ad_type        :string
#  is_front_page  :boolean
#  story_count    :integer
#  page_number    :integer
#  section_name   :string
#  color_page     :boolean          default("f")
#  publication_id :integer          default("1")
#  layout         :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
