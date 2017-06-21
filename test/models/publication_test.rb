# == Schema Information
#
# Table name: publications
#
#  id                 :integer          not null, primary key
#  name               :string
#  paper_size         :string
#  width              :float
#  height             :float
#  left_margin        :float
#  top_margin         :float
#  right_margin       :float
#  bottom_margin      :float
#  lines_per_grid     :integer
#  divider            :float
#  gutter             :float
#  page_count         :integer
#  section_names      :text
#  front_page_heading :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class PublicationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
