
RLayout::NewsAdBox.new(is_ad_box: true, column: 7, row: 5, grid_width: 146.99662542182014, grid_height: 97.32283464566807, page_heading_margin_in_lines: 0) do
  image(image_path: 'some_image_path', layout_expand: [:width, :height])
  relayout!
end
