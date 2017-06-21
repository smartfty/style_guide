RLayout::Container.new(width: 1200, height: 41.54771428571429, layout_direction: 'horinoztal', stroke_sizes: [0,0,0,1], stroke_width: 0.3) do
  text('24', font: 'Helvetica', text_size: 32, width: 50, height: 44)
  container(layout_expand: :width, layout_direction: 'horinoztal', layout_length: 20, layout_align: 'justified') do
    text('2017년 5월 5일 수요일', width: 200, text_size: 18, text_alignment: 'left')
    text('기획', width: 200, text_size: 24)
    text('내일신문', width: 230, text_alignment: 'right', text_size: 18,)
  end
  relayout!
end
