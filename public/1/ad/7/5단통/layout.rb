RLayout::NewsArticleBox.new(column: 7, row:5, grid_width: 147.22142857142856, grid_height: 105.58533333333334, gutter:10.0, is_ad_box: true, grid_base: [7, 5] ) do
  image(image_path: '1.jpg', layout_expand: [:width, :height], grid_frame: [0,0, 7, 5], is_float: true)
  layout_floats!
end
