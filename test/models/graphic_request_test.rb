# == Schema Information
#
# Table name: graphic_requests
#
#  id               :bigint(8)        not null, primary key
#  date             :date
#  title            :string
#  requester        :string
#  person_in_charge :string
#  status           :string
#  description      :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class GraphicRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
