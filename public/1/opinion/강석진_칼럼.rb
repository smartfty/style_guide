RLayout::Container.new(width:171.496083,  height: 165.219) do
  line(x: 0 , y:1, width: 171.496083, stroke_width: 2, height:0)
  text('신문로', y:5, font: 'KoPubDotumPB', font_size: 12, width: 170)
  rect(x: 0, y: 70, width:171.496083, height: 65,  fill_color:"CMYK=0,0,0,10")
  
    
    image(local_image: '강석진.eps', y: 60, width: 60, height: 75, fill_color: 'clear')
  
  container(x: 70, y: 80, width:150, bottom_margin: 10, fill_color: 'clear') do
    
      text('언론인', y:30, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
      text('전 서울신문 편집국장', y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
    
  end
end
