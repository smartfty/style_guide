# == Schema Information
#
# Table name: working_articles
#
#  id             :integer          not null, primary key
#  column         :integer
#  row            :integer
#  order          :integer
#  profile        :string
#  title          :text
#  subtitle       :text
#  body           :text
#  reporter       :string
#  email          :string
#  personal_image :string
#  image          :string
#  quote          :text
#  name_tag       :string
#  is_front_page  :boolean
#  top_story      :boolean
#  top_position   :boolean
#  kind           :string
#  page_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class WorkingArticleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
