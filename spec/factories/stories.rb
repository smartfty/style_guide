FactoryBot.define do
  factory :story do
    user { nil }
    working_article { nil }
    title { "MyString" }
    subtile { "MyString" }
    body { "MyText" }
    quoute { "MyText" }
    status { "MyString" }
    char_count { 1 }
    published { false }
    path { "MyString" }
    section { "MyString" }
  end
end
