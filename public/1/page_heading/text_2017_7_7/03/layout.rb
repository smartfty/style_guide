# width="1028.98px" height="54.425px" viewBox="0 0 1028.98 54.425" enable-background="new 0 0 1028.98 54.425"
#
# <text transform="matrix(1 0 0 1 491.0938 15.6963)" fill="#221E1F" font-family="'YDVYMjOStd14-KSCpc-EUC-H'" font-size="20">정 치</text>
# <text transform="matrix(1 0 0 1 1003.5244 18.105)" fill="#221E1F" font-family="'YDVYGOStd12-KSCpc-EUC-H'" font-size="24">23</text>
# <text transform="matrix(0.9 0 0 1 914.5693 17.4961)" fill="#221E1F" font-family="'YDVYGOStd12-KSCpc-EUC-H'" font-size="9.5">2017년 7월 12일 수요일</text>

RLayout::Container.new(width: 1028.98, height: 54.425, layout_direction: 'horinoztal') do
  text('정치', x:491.1611, y: 1, width: 50, font: 'YDVYMjOStd14',  font_size: 20, text_color: "#221E1F")
  text('2017년 5월 11일 목요일', x: 900.5693, y: 10,  width: 104, font: 'YDVYGOStd12', font_size: 9.5, text_color: "#221E1F", text_alignment: 'left')
  text('23', x: 998, y: 1, font: 'YDVYGOStd14', font_size: 24, text_color: "#221E1F", width: 50, height: 44)
  line(x: -3, width: 1037.81, y: 23.803, stroke_width: 0.3, stroke_color: "#221E1F")
  line(x: -3, width: 1037.81, y: 25.903, stroke_width: 0.3, stroke_color: "#221E1F")
end
