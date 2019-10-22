
RLayout::NewsAdBox.new(is_ad_box: true, column: 6, row: 15, grid_width: 171.49606299212363, grid_height: 97.32283464566795, on_left_edge: true, on_right_edge: true, top_position: true, page_heading_margin_in_lines: 3) do
  image(image_path: 'some_image_path', fit_type: 4, layout_expand: [:width, :height])
  relayout!
end
