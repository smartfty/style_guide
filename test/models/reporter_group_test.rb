# == Schema Information
#
# Table name: reporter_groups
#
#  id            :integer          not null, primary key
#  section       :string
#  page_range    :string
#  leader        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_code :integer
#

require 'test_helper'

class ReporterGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
