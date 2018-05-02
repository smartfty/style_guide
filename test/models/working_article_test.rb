# == Schema Information
#
# Table name: working_articles
#
#  id                  :integer          not null, primary key
#  grid_x              :integer
#  grid_y              :integer
#  column              :integer
#  row                 :integer
#  order               :integer
#  kind                :string
#  profile             :string
#  title               :text
#  title_head          :string
#  subtitle            :text
#  subtitle_head       :string
#  body                :text
#  reporter            :string
#  email               :string
#  personal_image      :string
#  image               :string
#  quote               :text
#  subject_head        :string
#  on_left_edge        :boolean
#  on_right_edge       :boolean
#  is_front_page       :boolean
#  top_story           :boolean
#  top_position        :boolean
#  inactive            :boolean
#  extended_line_count :integer
#  pushed_line_count   :integer
#  article_id          :integer
#  page_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  quote_box_size      :integer
#
# Indexes
#
#  index_working_articles_on_article_id  (article_id)
#  index_working_articles_on_page_id     (page_id)
#

require 'test_helper'

class WorkingArticleTest < ActiveSupport::TestCase
  test "add_extra_line_between_paragraphs" do
    assert true
  end
end
