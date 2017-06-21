json.extract! image_template, :id, :column, :row, :height_in_lines, :image_path, :caption_title, :caption, :position, :page_columns, :article_id, :publication_id, :created_at, :updated_at
json.url image_template_url(image_template, format: :json)
