# == Schema Information
#
# Table name: articles
#
#  id             :integer          not null, primary key
#  column         :integer
#  row            :integer
#  order          :integer
#  profile        :integer
#  title          :string
#  subtitle       :string
#  body           :text
#  reporter       :string
#  email          :string
#  personal_image :string
#  image          :string
#  quote          :string
#  name_tag       :string
#  is_front_page  :boolean
#  top_story      :boolean
#  top_position   :boolean
#  kind           :string
#  page_columns   :integer
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
