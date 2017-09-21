json.extract! image, :id, :column, :row, :extra_height_in_lines, :image_path, :caption_title, :caption, :position, :working_article, :created_at, :updated_at
json.url image_url(image, format: :json)
