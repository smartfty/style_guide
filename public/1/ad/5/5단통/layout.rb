RLayout::NewsArticleBox.new(column: 5, row:5, grid_width: 210.10999999999999, grid_height: 105.58533333333334, gutter:10.0, is_ad_box: true, grid_base: [5, 5] ) do
  image(image_path: 'some_path', layout_expand: [:width, :height], grid_frame: [0,0, 5, 5], is_float: true)
  layout_floats!
end
