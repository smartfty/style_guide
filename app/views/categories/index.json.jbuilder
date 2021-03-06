json.set! :data do
  json.array! @categories do |category|
    json.partial! 'categories/category', category: category
    json.url  "
              #{link_to 'Show', category }
              #{link_to 'Edit', edit_category_path(category)}
              #{link_to 'Destroy', category, method: :delete, data: { confirm: '정말 삭제하시겠습니까??' }}
              "
  end
end