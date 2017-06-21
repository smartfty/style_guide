RLayout::NewsArticleBox.new(column: 3, row:9, grid_width: 147.22142857142856, grid_height: 105.58533333333334, gutter:10.0, is_ad_box: true, grid_base: [3, 9] ) do
  image(image_path: 'some_path', layout_expand: [:width, :height], grid_frame: [0,0, 3, 9], is_float: true)
  layout_floats!
end
