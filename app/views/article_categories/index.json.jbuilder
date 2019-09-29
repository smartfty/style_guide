json.set! :data do
  json.array! @article_categories do |article_category|
    json.partial! 'article_categories/article_category', article_category: article_category
    json.url  "
              #{link_to 'Show', article_category }
              #{link_to 'Edit', edit_article_category_path(article_category)}
              #{link_to 'Destroy', article_category, method: :delete, data: { confirm: '정말 삭제하시겠습니까??' }}
              "
  end
end