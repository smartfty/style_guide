RLayout::Container.new(width:171.496083,  height: 165.219) do
  line(x: 0 , y:1, width: 171.496083, stroke_width: 2, height:0)
  text('유철규 칼럼', y:5, font: 'KoPubDotumPB', font_size: 12, width: 170)
  rect(x: 0, y: 70, width:171.496083, height: 65,  fill_color:"CMYK=0,0,0,10")
  
    image(local_image: '유철규.eps', y: 60, width: 60, height: 75, fill_color: 'clear')
  
  container(x: 70, y: 80, width:150, bottom_margin: 10, fill_color: 'clear') do
    
      
        text('유철규', y:17, font: 'KoPubDotumPB', font_size: 9, fill_color: 'clear')
      
      text('성공회대 교수', y:30, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
      text('경제학', y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
    
  end
end
