RLayout::NewsArticleBox.new(column: 6, row:5, grid_width: 173.42499999999998, grid_height: 105.58533333333334, gutter:10.0, grid_base: [6, 5] ) do
  image(image_path: 'some_path', layout_expand: [:width, :height], grid_frame: [0,0, 6, 5], is_float: true)
  layout_floats!
end
