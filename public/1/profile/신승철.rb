RLayout::Container.new(width:170,  height: 85) do
  rect(x: 0, y: 10, width:158.737, height: 65,  fill_color:"CMYK=0,0,0,10")
  image(local_image: '신승철.eps', from_right: 9, y: 0, width: 60, height: 75, fill_color: 'clear')
  container(x: 0, y: 20, width:100, bottom_margin: 10, fill_color: 'clear') do
    
      
      text('신승철', text_alignment: 'right', from_right: 10, y:17, font: 'KoPubDotumPB', font_size: 9, fill_color: 'clear')
      
      text('중남미지역경제협력대사', text_alignment: 'right', from_right: 10, y:30, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
      text('한/중남미협회장', text_alignment: 'right', from_right: 10, y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
    
  end
end
