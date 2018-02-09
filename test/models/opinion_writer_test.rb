# == Schema Information
#
# Table name: opinion_writers
#
#  id             :integer          not null, primary key
#  name           :string
#  title          :string
#  work           :string
#  position       :string
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class OpinionWriterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
