# == Schema Information
#
# Table name: text_styles
#
#  id                    :integer          not null, primary key
#  korean_name           :string
#  english               :string
#  category              :string
#  font_family           :string
#  font                  :string
#  font_size             :float
#  text_color            :string
#  alignment             :string
#  tracking              :float
#  space_width           :float
#  scale                 :float
#  text_line_spacing     :float
#  space_before_in_lines :integer
#  space_after_in_lines  :integer
#  text_height_in_lines  :integer
#  box_attributes        :text
#  markup                :string
#  dynamic_style         :text
#  publication_id        :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'test_helper'

class TextStyleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
