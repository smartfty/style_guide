
RLayout::NewsAdBox.new(is_ad_box: true, column: 4, row: 9, grid_width: 146.99664257142857, grid_height: 96.377964, gutter: 12.755907, page_heading_margin_in_lines: 3) do
  image(image_path: 'some_path', layout_expand: [:width, :height])
  relayout!
end
