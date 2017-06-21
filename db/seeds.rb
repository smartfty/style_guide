# require 'csv'
#
p = Publication.where(name: '내일신문', paper_size: 'custom', width: 1116.85,  height: 1539.21, left_margin: 42.52, top_margin: 42.52, right_margin: 42.52, bottom_margin: 42.52, lines_per_grid: 7, divider: 20, gutter: 10, page_count:24).first_or_create
# #
NEWSPAPER_STYLE = [
  {:name=>"본문명조", :english=>"body", :font_family=>"윤신문명조", :font=>"YDVYSinStd", :font_size=>9.6, :color=>"", :alignment=>"justified", :tracking=>-0.5, :space_width=>5.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"본문고딕", :english=>"body_gothic", :font_family=>"윤고딕120", :font=>"YDVYGOStd12", :font_size=>9.4, :color=>"", :alignment=>"justified", :tracking=>-0.5, :space_width=>5.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"본문중제", :english=>"running_head", :font_family=>"윤고딕130", :font=>"YDVYGOStd13", :font_size=>9.6, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>5.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"발문", :english=>"quote", :font_family=>"윤명조130", :font=>"YDVYMjOStd13", :font_size=>12.0, :color=>"", :alignment=>"center", :tracking=>-0.5, :space_width=>6.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"관련기사", :english=>"related_story", :font_family=>"윤고딕120", :font=>"YDVYGOStd12", :font_size=>9.4, :color=>"", :alignment=>"right", :tracking=>-0.5, :space_width=>5.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"사진제목", :english=>"caption_title", :font_family=>"윤고딕140", :font=>"YDVYGOStd14", :font_size=>8.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>4.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"사진설명", :english=>"caption", :font_family=>"윤고딕120", :font=>"YDVYGOStd12", :font_size=>8.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>4.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"사진출처", :english=>"source", :font_family=>"윤고딕120", :font=>"YDVYGOStd12", :font_size=>7.0, :color=>"", :alignment=>"right", :tracking=>-0.5, :space_width=>4.0, :scale=>80.0, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"기자명", :english=>"reporter", :font_family=>"윤고딕120", :font=>"YDVYGOStd12", :font_size=>8.0, :color=>"", :alignment=>"right", :tracking=>-0.5, :space_width=>5.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"제목_메인", :english=>"title_top", :font_family=>"윤명조140", :font=>"YDVYMjOStd14", :font_size=>42.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>21.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>2.0, :text_height_in_lines=>4.0, :space_after_in_lines=>2.0, :publication_id=>1},
  {:name=>"제목_4-5단", :english=>"title_4_5", :font_family=>"윤명조140", :font=>"YDVYMjOStd14", :font_size=>32.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>18.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>2.0, :text_height_in_lines=>4.0, :space_after_in_lines=>2.0, :publication_id=>1},
  {:name=>"제목_3단", :english=>"title_3", :font_family=>"윤명조140", :font=>"YDVYMjOStd14", :font_size=>26.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>13.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>2.0, :text_height_in_lines=>4.0, :space_after_in_lines=>2.0, :publication_id=>1},
  {:name=>"제목_2단", :english=>"title_2", :font_family=>"윤명조140", :font=>"YDVYMjOStd14", :font_size=>22.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>11.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>1.0, :text_height_in_lines=>3.0, :space_after_in_lines=>2.0, :publication_id=>1},
  {:name=>"제목_1단", :english=>"title_1", :font_family=>"윤명조140", :font=>"YDVYMjOStd14", :font_size=>15.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>7.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>1.0, :text_height_in_lines=>3.0, :space_after_in_lines=>2.0, :publication_id=>1},
  {:name=>"부제_메인", :english=>"subtitle_18", :font_family=>"윤명조140", :font=>"YDVYMjOStd14", :font_size=>18.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>9.0, :scale=>100.0, :text_line_spacing=>6.0, :space_before_in_lines=>1.0, :text_height_in_lines=>2.0, :space_after_in_lines=>1.0, :publication_id=>1},
  {:name=>"부제_14", :english=>"subtitle_14", :font_family=>"윤명조140", :font=>"YDVYMjOStd14", :font_size=>14.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>7.0, :scale=>100.0, :text_line_spacing=>7.0, :space_before_in_lines=>1.0, :text_height_in_lines=>2.0, :space_after_in_lines=>1.0, :publication_id=>1},
  {:name=>"부제_12", :english=>"subtitle_12", :font_family=>"윤명조140", :font=>"YDVYMjOStd14", :font_size=>12.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>6.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"뉴스라인_제목", :english=>"news_line_title", :font_family=>"윤고딕120", :font=>"YDVYGOStd12", :font_size=>13.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>6.0, :scale=>nil, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"애드_브랜드명", :english=>"brand_name", :font_family=>"윤고딕130", :font=>"YDVYMjOStd13", :font_size=>13.0, :color=>"", :alignment=>"center", :tracking=>-0.5, :space_width=>6.0, :scale=>nil, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"문패_18", :english=>"name_tag-18", :font_family=>"윤고딕140", :font=>"YDVYGOStd14", :font_size=>18.0, :color=>"CMYK=100,60,0,0", :alignment=>"left", :tracking=>-0.5, :space_width=>9.0, :scale=>nil, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"문패_14", :english=>"name_tag-14", :font_family=>"윤고딕140", :font=>"YDVYGOStd14", :font_size=>14.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>7.0, :scale=>100.0, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"문패_12", :english=>"name_tag-12", :font_family=>"윤고딕140", :font=>"YDVYGOStd14", :font_size=>12.0, :color=>"", :alignment=>"left", :tracking=>-0.5, :space_width=>6.0, :scale=>nil, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1},
  {:name=>"편집자주", :english=>"editor_note", :font_family=>"윤고딕130", :font=>"YDVYGOStd13", :font_size=>8.8, :color=>"CMYK=0,0,0,80", :alignment=>"left", :tracking=>-0.5, :space_width=>5.0, :scale=>nil, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :publication_id=>1}
]


NEWSPAPER_STYLE.each do |atts|
    atts[:publication] = p
    TextStyle.where(atts).first_or_create
end

# title     = '제목은 여기에 여기는 제목'
# subtitle  = '부제는 여기에 여기는 부제목 자리'
# reporter  = '홍길동'
# email     = 'gdhong@gmail.com'
#
# body =<<EOF
# 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.
#
# 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.
#
# 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.
#
# 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.
#
# 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다. 여기는 본문이 입니다.
#
# EOF
#

# Lets do image_template, as something similar to section layout
# create image_template for each article size and let the user pick the image layout form it
# this will restrict users from laying out undesired layout
# image_templates have parent_column and parent_row
# where as images do not.
# User is able to select from given image_templates where parent_column and parent_row is alreay set for Image

# image           = 'sample_image.jpg'
# personal_image  = 'sample_personal_image.jpg'
# quote           = "이부분이 이용한 부분입니다. 이부분은 본문 중간에 위치 하게 됩니다. 아마도 이부분이 좀던 눈에 띠게 해야 합나다."
# extra_paragraph = "\n#{quote}"*3
#
# (6..7).to_a.each do |page_columns|
#   (1..page_columns).to_a.each do |column|
#     options                 = {publication: p,}
#     options[:parent_column]  = page_columns
#     options[:column]        = column
#     options[:title]         = title
#     options[:subtitle]      = subtitle unless column == 1
#     options[:body]          = body
#     if column == 5
#       options[:body] += extra_paragraph
#     elsif column == 6
#       options[:body] += extra_paragraph*7
#     elsif column == 7
#       options[:body] += extra_paragraph*10
#     end
#     options[:reporter]  = reporter
#     options[:email]     = email
#     options[:top_story] = false
#     [2,3,4,5,6,7,8,9,10].each do |row|
#       options[:row]             = row
#       options[:kind]            = 0
#       options[:top_position]    = false
#       options[:is_front_page] = false
#       Article.where(options.dup).first_or_create
#       # top_position for front page
#       options_1                 = options.dup
#       options_1[:top_position]  = true
#       options_1[:is_front_page] = false
#       options_1[:kind]          = 1
#
#       Article.where(options.dup).first_or_create
#       # top_position for front page
#       options_1                 = options.dup
#       options_1[:top_position]  = true
#       options_1[:is_front_page] = true
#       options_1[:kind]        = 2
#
#       Article.where(options_1).first_or_create
#       if column >= 3
#         options_2 = options.dup
#         options_2[:top_story]     = true
#         options_2[:top_position]  = true
#         options_2[:kind]          = 3
#         Article.where(options_2).first_or_create
#
#         options_3                 = options.dup
#         options_3[:is_front_page] = true
#         options_3[:top_story]     = true
#         options_3[:top_position]  = true
#         options_3[:kind]          = 4
#         Article.where(options_3).first_or_create
#       end
#     end
#   end
# end
#
# ad_csv_path = "#{Rails.root}/db/ads.csv"
# csv_text = File.read(ad_csv_path)
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#   Ad.where(row.to_hash).first_or_create
# end
#
# image_folder     = "#{Rails.root}/public/images"
# image_samples    = Dir.glob("#{image_folder}/*.jpg")
# image_path       = 'sample_image.jpg'
# caption_title    = '사진제목 부분입니다'
# caption          = '여기는 사진설명 부분 입니다. 사진설명을 여기에 입역합니다'
# (6..7).to_a.each do |page_columns|
#     options                 = {}
#     options[:publication_id] = p.id
#     options[:page_columns]   = page_columns
#     options[:image_path]     = image_samples.sample
#     options[:caption_title]  = caption_title
#     options[:caption]        = caption
#     (1..6).to_a.each do |column|
#       (1..10).to_a.each do |row|
#         options[:position]        = 3
#         options[:column]          = column
#         options[:row]             = row
#         options[:height_in_lines] = row * p.lines_per_grid
#         result = ImageTemplate.where(options).first_or_create
#       end
#     end
# end
#




# # parse section.csv
# csv_path = "#{Rails.root}/public/1/section/sections.csv"
# csv_text = File.read(csv_path)
# # csv = CSV.parse(csv_text, :headers => true)
# csv = CSV.parse(csv_text)
# keys  = csv.shift
# keys.map!{|e| e.to_sym}
# column_index          = keys.index('column')
# row_index             = keys.index('row')
# page_number_index     = keys.index('page_number')
# section_name_index    = keys.index('section_name')
# divider_position_index = keys.index('divider_position')
# layout_index          = keys.index('layout')
#
# csv.each do |row|
#   row_h = Hash[keys.zip row]
#   row_h.delete(:profile)
#   # Member.create!(row.to_hash)
#   Section.where(row_h).first_or_create
# end
#
# sample_issue = [
#   '국제통일',
#   '금융',
#   '정치',
#   '전면광고',
#   '자치행정',
#   '국제경제',
#   '상업',
#   '정책',
#   '기획',
#   '오피니언'
# ]

# issue = Issue.where(id: 1, date: Date.new(2017,5,30), number: '00001', publication_id: 1).first_or_create
#
# issue.parse_images
