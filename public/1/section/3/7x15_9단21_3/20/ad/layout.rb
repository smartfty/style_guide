
RLayout::NewsAdBox.new(is_ad_box: true, column: 4, row: 9, grid_width: 146.99664257142857, grid_height: 96.377964, page_heading_margin_in_lines: 0) do
  image(image_path: 'some_image_path', layout_expand: [:width, :height])
  relayout!
end
