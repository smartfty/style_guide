require 'erb'
require 'pry'

SECTIONS = [
  '1면',
  '정치',
  '정치',
  '정치',
  '행정',
  '행정',
  '전면광고',
  '국제통일',
  '전면광고',
  '금융',
  '전면광고',
  '금융',
  '금융',
  '산업',
  '산업',
  '산업',
  '산업',
  '정책',
  '정책',
  '기획',
  '기획',
  '오피니언',
  '오피니언',
  '전면광고'
]
@date_1 = '2017년 5월 11일 목요일 (4200호)'
@date = "2017년 5월 11일 목요일"

Dir.glob("#{File.dirname(__FILE__)}/**/layout.erb").each_with_index do |e, i|
  template_file = File.open(e, 'r').read
  if i == 0
    @date = '2017년 5월 11일 목요일 (4200호)'
  else
    @date = "2017년 5월 11일 목요일"
  end
  @page_number = e.split("/")[1].to_i
  @section_name = SECTIONS[@page_number - 1]
  erb = ERB.new(template_file)
  layout_rb = erb.result(binding)
  layout_path = File.expand_path(e.sub(".erb", '.rb'))

  # puts "layout_path:#{layout_path}"
  # puts "layout_rb:#{layout_rb}"
  File.open(layout_path, 'w') { |file| file.write(layout_rb) }
  layout_folder = File.dirname(layout_path)
  system("cd #{layout_folder} && /Applications/rjob.app/Contents/MacOS/rjob .")
end
