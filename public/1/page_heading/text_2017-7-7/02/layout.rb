# width="1028.98px" height="54.425px" viewBox="0 0 1028.98 54.425" enable-background="new 0 0 1028.98 54.425"
#
# <text transform="matrix(1 0 0 1 491.1611 15.6309)" fill="#221E1F" font-family="'YDVYMjOStd14-KSCpc-EUC-H'" font-size="20">정 치</text>
# <text transform="matrix(1 0 0 1 1.9795 18.0396)" fill="#221E1F" font-family="'YDVYGOStd12-KSCpc-EUC-H'" font-size="24">20</text>
# <text transform="matrix(0.9 0 0 1 33.5356 17.4307)" fill="#221E1F" font-family="'YDVYGOStd12-KSCpc-EUC-H'" font-size="9.5">2017년 7월 12일 수요일</text>
#
RLayout::Container.new(width: 1028.98, height: 54.425, layout_direction: 'horinoztal') do
  text('<%= @section_name %>', x:491.1611, y: 1, width: 50, font: 'YDVYMjOStd14',  font_size: 20, text_color: "#221E1F")
  text('<%= @page_number %>', x: 1.9795, y: 1, font: 'YDVYGOStd14', font_size: 24, text_color: "#221E1F", width: 50, height: 44)
  text('<%= @issue_date %>', x: 33.5356, y: 10,  width: 200, font: 'YDVYGOStd12', font_size: 9.5, text_color: "#221E1F", text_alignment: 'left')
  line(x: -3, width: 1037.81, y: 23.803, stroke_width: 0.3, stroke_color: "#221E1F")
  line(x: -3, width: 1037.81, y: 25.903, stroke_width: 0.3, stroke_color: "#221E1F")
end
