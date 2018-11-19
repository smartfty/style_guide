
RLayout::NewsAdBox.new(is_ad_box: true, column: 6, row: 15, grid_width: 171.49606299212348, grid_height: 97.32283464566807, page_heading_margin_in_lines: 3) do
  image(image_path: 'some_image_path', layout_expand: [:width, :height])
  relayout!
end
