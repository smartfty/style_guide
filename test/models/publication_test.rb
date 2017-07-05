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
#  page_columns :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require_relative '../test_helper'

class PublicationTest < ActiveSupport::TestCase

  test "should create Publication" do
    p = Publication.new(name: '내일신문', paper_size: 'custom', width: 1116.85,  height: 1539.21, left_margin: 42.52, top_margin: 42.52, right_margin: 42.52, bottom_margin: 42.52, lines_per_grid: 7, gutter: 10, page_count:24)
    assert p.save
    assert_equal 1116.85, p.width
    assert_equal 147.40142857142857, p.grid_width(7)
    assert_equal (p.left_margin), p.x_of_grid_frame(7, [0,0,7,5])
    assert_equal (p.top_margin), p.x_of_grid_frame(7, [0,0,7,5])
    assert_equal (p.width - p.left_margin - p.right_margin), p.width_of_grid_frame(7, [0,0,7,5])
    assert_equal (p.width - p.left_margin - p.right_margin)*2/7, p.width_of_grid_frame(7, [0,0,2,5])
    assert_equal (p.width - p.left_margin - p.right_margin)*3/7, p.width_of_grid_frame(7, [0,0,3,5])
    assert_equal (p.height - p.top_margin - p.bottom_margin), p.height_of_grid_frame(7, [0,0,7,15])
  end
  #
  # test "should create Publication" do
  #
  #   p = Publication.new(name: '내일신문', paper_size: 'custom', width: 1116.85,  height: 1539.21, left_margin: 42.52, top_margin: 42.52, right_margin: 42.52, bottom_margin: 42.52, lines_per_grid: 7, divider: 20, gutter: 10, page_count:24)
  #
  #   # some_undefined_variable is not defined elsewhere in the test case
  #   assert_raises(NameError) do
  #     some_undefined_variable
  #   end
  # end
  # test "the truth" do
  #   assert true
  # end
end
