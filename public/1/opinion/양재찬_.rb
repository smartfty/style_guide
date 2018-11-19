RLayout::Container.new(width:158.74015748031,  height: 166.83914494488) do
  line(x: 0 , y:1, width: 158.74015748031, stroke_width: 2, height:0, storke_color:"CMYK=0,0,0,100")
  text('양재찬 칼럼', x: 0, y:5, font: 'KoPubDotumPB', font_size: 12, width: 170, text_color:"CMYK=0,0,0,100")
  rect(x: 0, y: 70, width:158.74015748031, height: 65,  fill_color:"CMYK=0,0,0,10")
  
    
    image(local_image: '양재찬.eps', y: 60, width: 60, height: 75, fill_color: 'clear')
  
  container(x: 70, y: 80, width:150, bottom_margin: 10, fill_color: 'clear') do
    
      text('한양대 겸임교수', y:30, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear', text_color:"CMYK=0,0,0,100" )
      text('경제저널리즘 박사', y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear', text_color:"CMYK=0,0,0,100")
    
  end
end
