json.extract! publication, :id, :name, :paper_size, :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin, :lines_per_grid, :divider, :gutter, :page_count, :section_names, :front_page_heading, :created_at, :updated_at
json.url publication_url(publication, format: :json)
