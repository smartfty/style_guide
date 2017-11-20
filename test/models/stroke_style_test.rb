# == Schema Information
#
# Table name: stroke_styles
#
#  id             :integer          not null, primary key
#  klass          :string
#  name           :string
#  stroke         :text
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class StrokeStyleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
