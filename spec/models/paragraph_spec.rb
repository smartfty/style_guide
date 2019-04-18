# == Schema Information
#
# Table name: paragraphs
#
#  id                 :bigint(8)        not null, primary key
#  name               :string
#  working_article_id :bigint(8)
#  order              :integer
#  para_text          :text
#  tokens             :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_paragraphs_on_working_article_id  (working_article_id)
#
# Foreign Keys
#
#  fk_rails_...  (working_article_id => working_articles.id)
#

require 'rails_helper'

RSpec.describe Paragraph, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
