# == Schema Information
#
# Table name: article_sub_categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ArticleSubCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
