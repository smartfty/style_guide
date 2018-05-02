# == Schema Information
#
# Table name: reporters
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  title             :string
#  cell              :string
#  reporter_group_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_reporters_on_reporter_group_id  (reporter_group_id)
#

require 'test_helper'

class ReporterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
