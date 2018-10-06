RLayout::Container.new(width: 1028.9763779528, height: 41.385826771654, layout_direction: 'horinoztal') do
  image(local_image: 'even.pdf', x: 0, y: 0, width: 1028.9763779528, height: 41.385826771654, fit_type: 0)
    text('<%= @section_name %>', x: 464.0, y: -2, width: 100, font: 'KoPubBatangPM',  font_size: 20.5, text_color: "CMYK=0,0,0,100", text_alignment: 'center', fill_color:'clear')
  text('<%= @page_number %>', tracking: -0.2, x: 0, y: -8.97, font: 'Helvetica-Light', font_size: 36, text_color: "CMYK=0,0,0,100", width: 50, height: 44, fill_color: 'clear')
  text('<%= @date %>', tracking: -0.7, x: 50, y: 9.66, width: 200, font: 'KoPubDotumPL', font_size: 10.5, text_color: "CMYK=0,0,0,100", text_alignment: 'left', fill_color: 'clear')
end
