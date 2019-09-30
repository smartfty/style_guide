# == Schema Information
#
# Table name: article_categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ArticleCategory < ApplicationRecord
    belongs_to :story
    belongs_to :working_article
    has_one :article_subcategory
end
