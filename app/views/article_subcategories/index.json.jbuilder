json.set! :data do
  json.array! @article_subcategories do |article_subcategory|
    json.partial! 'article_subcategories/article_subcategory', article_subcategory: article_subcategory
    json.url  "
              #{link_to 'Show', article_subcategory }
              #{link_to 'Edit', edit_article_subcategory_path(article_subcategory)}
              #{link_to 'Destroy', article_subcategory, method: :delete, data: { confirm: '정말 삭제하시겠습니까??' }}
              "
  end
end