json.extract! working_article, :id, :column, :row, :order, :profile, :title, :subtitle, :body, :reporter, :email, :personal_image, :image, :quote, :name_tag, :is_front_page, :top_story, :top_position, :page_id, :created_at, :updated_at
json.url working_article_url(working_article, format: :json)
