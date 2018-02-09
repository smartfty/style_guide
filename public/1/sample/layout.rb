RLayout::Container.new({:width=>1114.0158780000002, :height=>1544.88207, :left_margin=>42.519690000000004, :top_margin=>56.69292, :right_margin=>42.519690000000004, :bottom_margin=>42.519690000000004, :stroke_width=>0.5}) do
  rectangle(x: 42.519690000000004, y: 56.69292, width: 1028.976498, height: 137.68280571428573, fill_color: 'lightGray')
  rectangle(x: 42.519690000000004, y: 56.69292, width: 1028.976498, height: 55.07312228571429, fill_color: 'gray')
  rectangle(x: 42.519690000000004, y: 56.69292, width: 1028.976498, height: 41.304841714285715, fill_color: 'darkGray')

  x_position = 42.519690000000004
  7.times do
    rectangle(x: x_position, y: 56.69292, width: 136.063008, height: 1445.66946, stroke_width: 0.5, fill_color: 'clear')
    x_position += 136.063008 + 12.755907
  end
  y = 56.69292
  15.times do |i|
    line(x: 42.519690000000004, y: y , width: 1028.976498, height: 0, stroke_width: 0.6, stroke_color: 'red', fill_color: 'clear')
    line_top = y
    7.times do |j|
      line(x: 42.519690000000004, y: line_top , width: 1028.976498, height: 0, stroke_width: 0.1, stroke_color: 'red', fill_color: 'clear')
      line_top += 13.768280571428573
    end
    y += 96.377964
  end
end
