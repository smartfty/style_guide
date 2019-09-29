json.set! :data do
  json.array! @article_sub_categories do |article_sub_category|
    json.partial! 'article_sub_categories/article_sub_category', article_sub_category: article_sub_category
    json.url  "
              #{link_to 'Show', article_sub_category }
              #{link_to 'Edit', edit_article_sub_category_path(article_sub_category)}
              #{link_to 'Destroy', article_sub_category, method: :delete, data: { confirm: '정말 삭제하시겠습니까??' }}
              "
  end
end