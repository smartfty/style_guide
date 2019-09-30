# == Schema Information
#
# Table name: article_subcategories
#
#  id                    :bigint(8)        not null, primary key
#  name                  :string
#  code                  :string
#  article_categories_id :bigint(8)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_article_subcategories_on_article_categories_id  (article_categories_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_categories_id => article_categories.id)
#

require 'rails_helper'

RSpec.describe ArticleSubcategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
