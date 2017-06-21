# == Schema Information
#
# Table name: page_headings
#
#  id             :integer          not null, primary key
#  page_number    :integer
#  section_name   :string
#  date           :string
#  layout         :text
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class PageHeadingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
