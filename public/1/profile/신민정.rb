RLayout::Container.new(width:158.737,  height: 75) do
  rect(x: 0, y: 10, width:158.737, height: 65, fill_color:"CMYK=0,0,0,10")
  image(local_image: '신민정.eps', from_right: 0, y: 0, width: 60, height: 75, fill_color: 'clear')
  container(x: 0, y: 20, width:100, bottom_margin: 10, fill_color: 'clear') do
    
      
      text('신민정', text_alignment: 'right', from_right: 10, y:17, font: 'KoPubDotumPB', font_size: 9,font_color:"CMYK=0,0,0,10", fill_color: 'clear')
      
      text('변호사', text_alignment: 'right', from_right: 10, y:30, font: 'KoPubDotumPL', font_size: 8, font_color:"CMYK=0,0,0,10", fill_color: 'clear')
      text('여성변호사회 대외협력이사', text_alignment: 'right', from_right: 10, y:41, font: 'KoPubDotumPL', font_size: 8, font_color:"CMYK=0,0,0,10", fill_color: 'clear')
    
  end
end
