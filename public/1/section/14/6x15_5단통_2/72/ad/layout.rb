
RLayout::NewsAdBox.new(is_ad_box: true, column: 6, row: 5, grid_width: 171.496062992123, grid_height: 97.322834551181, page_heading_margin_in_lines: 0) do
  image(image_path: 'some_image_path', layout_expand: [:width, :height])
  relayout!
end
