# == Schema Information
#
# Table name: profiles
#
#  id             :integer          not null, primary key
#  name           :string
#  profile_image  :string
#  work           :string
#  position       :string
#  email          :string
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_profiles_on_publication_id  (publication_id)
#

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
