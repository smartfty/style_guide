
RLayout::NewsAdBox.new(is_ad_box: true, column: 7, row: 7, grid_width: 146.99662542182026, grid_height: 97.32283464566795, on_left_edge: true, on_right_edge: true, top_position: false, page_heading_margin_in_lines: 0) do
  image(image_path: 'some_image_path', fit_type: 4, layout_expand: [:width, :height])
  relayout!
end
