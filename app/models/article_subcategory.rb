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

class ArticleSubcategory < ApplicationRecord
    belongs_to :story
    belongs_to :working_article
    belongs_to :article_category
end
