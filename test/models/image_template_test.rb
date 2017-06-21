# == Schema Information
#
# Table name: image_templates
#
#  id              :integer          not null, primary key
#  column          :integer
#  row             :integer
#  height_in_lines :integer
#  image_path      :string
#  caption_title   :string
#  caption         :string
#  position        :integer
#  page_columns    :integer
#  article_id      :integer
#  publication_id  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class ImageTemplateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
