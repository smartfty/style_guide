RLayout::Container.new(width:158.737,  height: 165.182) do
  line(x: 0 , y:1, width: 158.737, stroke_width: 2, height:0)
  text('신문로', x: 0, y:5, font: 'KoPubDotumPB', font_size: 12, width: 170)
  rect(x: 0, y: 70, width:158.737, height: 65,  fill_color:"CMYK=0,0,0,10")
  
    image(local_image: '조세영.eps', y: 60, width: 60, height: 75, fill_color: 'clear')
  
  container(x: 70, y: 80, width:150, bottom_margin: 10, fill_color: 'clear') do
    
      
        text('조세영', y:17, font: 'KoPubDotumPB', font_size: 9, fill_color: 'clear')
      
      text('동서대 일본연구센터 소장', y:30, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
      text('전 외교통상부 동북아국장', y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
    
  end
end
