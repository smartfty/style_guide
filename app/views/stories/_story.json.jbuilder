json.extract! story, :id, :user_id, :working_article_id, :title, :subtile, :body, :quoute, :status, :char_count, :published, :path, :section, :created_at, :updated_at
json.url story_url(story, format: :json)
