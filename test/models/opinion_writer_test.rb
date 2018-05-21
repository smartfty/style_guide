# == Schema Information
#
# Table name: opinion_writers
#
#  id             :integer          not null, primary key
#  name           :string
#  title          :string
#  work           :string
#  position       :string
#  email          :string
#  cell           :string
#  opinion_image  :string
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_code  :integer
#
# Indexes
#
#  index_opinion_writers_on_publication_id  (publication_id)
#
# Foreign Keys
#
#  fk_rails_...  (publication_id => publications.id)
#

require 'test_helper'

class OpinionWriterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
