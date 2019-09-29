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

FactoryBot.define do
  factory :article_category do
    name { "MyString" }
    code { "MyString" }
  end
end
