RLayout::Container.new(width: 1028.9763779528, height: 41.70978623622, layout_direction: 'horinoztal') do
  image(local_image: 'even.pdf', x: 0, y: 0, width: 1028.9763779528, height: 41.70978623622, fit_type: 0)
  t = text('국 제', font_size: 20.5, x: 464.0, y: -2, width: 100, font: 'KoPubBatangPM', text_color: "CMYK=0,0,0,100", fill_color:'clear', text_fit_type: 'fit_box_to_text', anchor_type: 'center')
  line(x: t.x, y:27.6, width: t.width, stroke_width: 1, height:0, storke_color:"CMYK=0,0,0,100")
  text('6', tracking: -0.2, x: 0, y: -8.97, font: 'Helvetica-Light', font_size: 36, text_color: "CMYK=0,0,0,100", width: 50, height: 44, fill_color: 'clear')
  text('2018년 9월 14일 금요일', tracking: -0.7, x: 50, y: 9.66, width: 200, font: 'KoPubDotumPL', font_size: 10.5, text_color: "CMYK=0,0,0,100", text_alignment: 'left', fill_color: 'clear')
end