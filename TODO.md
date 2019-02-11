

# TODO
- make demo video
- make user manual
- enable ace editor/Trix, or Quill
- paginate remote with kaminari

## get record with unique field (:layout)
- Section.distinct.pluck(:layout)

- fill_up words for article template
- use key to summit
  - parse svg and make pdf
  - page_headings
      - SVG to PDF
  - short key
  - progress wheel

  - body
    - fit_text

2019-2-10
  - add status to page
  - add send story, and wire_image from wire_service to newsGo 
  - add recieive story to newsGo 
  - add testing to StyleGuide
  
2019-2-2
  - combo_ad_box
  
2019-1-31
  - make default issue_plan as last issue_plan
    make marketing ad_plan as issue_plan
  - when working_article kind is changed to image,
    delte all text including subject_heading and save it.

2019-1-31
  - combo_box
    - base_ad
    - width
    - height
    - column
    - row
    - layout
    - profile
    - sub_ad_count


2019-1-30
  - image x_grid
  - graphic x_grid
  - when changing page_plan,
      check for page and ad_type to make sure that first page template does not get applied to inner page with same ad_type
2019-1-29
  resources :ad_boxes do
    member do
      patch 'upload_ad_image'
      get 'download_pdf'
    end
  end

  - 줄 늘이기 여러개 할 경우 에러
  - image fit_type
  - current_page, current_working_article

2019-1-28
  - boxed_subtitle_text delete it from db when not used
  - space between section_name

2019-1-25
  - 검색 메뉴추가
    페이지검색, 
    page edit tag
  - 기사 검색
    with one word search all field
  
  - add to Page closed:boolean
  -  lock page to make it uneditable
  - copy page
    as template
    with content
  
  - page library
      b 판  heading 수정
      copy to data and page(template or source)
  
  - 반단 사진 (.5 width)
    sub_grid_size
    
  - 부고/인사 박스 (obituary)
    제목 업고 부제목 간격

  - 특집? (special)
    테두리 [1,2,1,1]
    2 - 3단 
    문페
    제목 1단에서 시작
    
    기자사진

    - 사진 그래픽 xml 용 필드

  - 

  - 책소개 (book_review)
    - 사진 형태 반쪽 사진설명 우측

2019-1-24
  - 욱여넣기
  - in image and graphic size_string
    extra_height_in_lines = 0 unless extra_height_in_lines
  - 제목 없으면 제목박스 없이
  - text 영역별 글자수 계산
  - reporter_image 추가 
    - 나의 사진

  - b판
  - heading 바꾸기

  - 현제 page 를 템플렛 으로 저장/사용
    페이지 레이아웃 검색 날자별 
    칼렌더 UI for searching page

2019-1-23

  - update page pdf, when story is assigned
  - when line number is expanded, 
    working_article pdf doen't get updated even page pdf is updated

2019-1-22

  - empty image box with no uploaded image
  - replace uploaded image with another one
  - crop image
  - image fit_type

  - fix caption title
  - fix swap story error
  - story_asign unasign_story

2019-1-17
  - when page_plan section_name is changed, update page section_name, generate_pdf for page_heding
  
2019-1-15
  - image fit_type
  - image cropping
  - ad_booking calendar
  - caption title
  - story assign UI

  - concurrent-ruby
  - change pdf engine to ruby-rlayout
  - wire-service
  - BoxAd
  
2019-1-10
  - 면배열표 광고 정보 AdBox 로 저장 
  - 기사 배치 기사에서 설정 할 수 있도록
  - 정치면 이외면 적용
  - 왼쪽 9단21 광고 템플렉 꼬임 
  - 광고 입력 창 날짜별 한번에
   
2019-1-6
  - when page template is changed, make sure heading background is copied.
  - 저장된 단락스타일로 페이지 재생성할때 타임 스켐프로
    
2019-1-5
  - 기사 배치
    - 행정 과 정책 바뀜
  - image size, graphic size
    - make extra space inside picture area
  - size of image in cm pt
  
2019-1-4
  - story does not appear on page assignment page
    put date section 
    put page order if selected 
  - fix page heading background image not showing 

  - ad_plan input by date enter daily add at once per page
  - fix 저장 to take effect as 수정 botton in image and graphic panel 
  - 브리지 광고

2019-1-3
  - 1, 3, 5,  7,  9, 11 default color page
  - 24, 20, 18, 16, 14
  - story list size reporter 
  - 광고없음

  - add emphasis on subject_head
  - add text on top of image?
  - show image/column and grid size in pixels/cm

2018-12-27
  - add heading_columns to working_article
  
2018-12-26
  - add Category
  - fix speread
  - fix oveflow count

2018-12-23
  - #, ##, ###, ####
  - *, **, markup 다이아몬드 강조, 고딕강조
  - print status monitoring
  - article 
    spit, 
    expand_grid, expand_grid
    expand, reduce
    syblling, cuson
  
2018-12-21
  - add ad_plan
    date ad:text description
  - generate heading when changing page template
  - 저장된 단락스타일로 재생성시 regenerate heading 

2018-12-18
  - fix change to no_ad 
  - 행정, 광고없음 not showing
  - image box at top no margin
  - 15단통_전면 => 15단통
  - 광고없음 적용않됨
    면 배열표 이름 이 반영이 안됨
    자치행정 not updated
  - 광고올릴때 동일이름으로 저장

2018-12-17
  - embargo
  - image trimming
  - automatic timeout
  - add 7x15_9단21_4
  - keep current section selection values
  - add '광고없음' to page_plan edit when selecting ad_type
  - in change_template of page, 
    - don't copy config from section, generate from page
    - don't copy ad from section, generate from page
    - this means we don't have to generate pdf for section

2018-12-14
  - intersection_rect, adjust to local codinate
  - save_xml
    - filter {size} from title, subtitle,
    - filter multiple line
  - page 광고없음
  - Section index keep current selection info
  
2018-12-12
  - overlap rect size should add 2 lines above and draw a line at 2 lines below
  - overlap y must be adjust to first rect최근 성룡코리건 그러면 소송한평균내가 아니라국고가 100 분이 더 하고 그건그거 그냥 보면 존경을 시도좀 우리 좀아닌가아닌데 몰래몰라요오긴긴 배우의 면면을 cordinate
  - frame around image 

2018-12-11
  - embeded article, line above
  - create empty image box

2018-12-10
  - fix token breaking rule, prevent it from too tight space
    pass currnt token(space) count, if space count is less than 4 do not give and cushion 
  
  - title and subtitle, text goes beyond right edge
  - image box with empty picture
  - image keep image info 

2018-12-8
  - overlapping box
     overlapping image as separate article
     working_article overlap_box:text
  - reporter byline
  - show selected page thumb
  - download opinion_writer csv with category_code

2018-12-7
  - 기획, 정책, 순서 반대로
  - title right side cuts off
      wrong heading width with non-edge 
      char cushion value
  - heading align to grid
  - fix when pushed and pulled in both
  - upload image with info intact
  - for picture box, hide picture size control
  - announcement vertical alignment

2018-12-6
  - fix section.csv seed format
  - add update_section_layout after create action
  - add generate_pdf_with_stamp when updating working_article
  - fix section svg unit_width as 210/column
  - fix siblings search
  - handle page 100(even), 101(odd) page template
  - fix drawing page svg with push and pull
  - fix push and pull bug, 

2018-11-30
  - fix 7단-15 bug
  - on issue_plan, selecting page ad_type for page
    present only the types available for page
    100 and 101 for even and odd page type

2018-11-28
  - 7단15 ordering bug fix
    when make article order, skip ad_box, it was causing mixup

2018-11-27
  - story 에 관련 사진 추가

2018-11-27
  - fix image position bug
  - swap story and 사진
  - swap between andy story and 사진
  - 안내문 템플렛 이동시 자동 위치 유지
  - 부제목 1, 2 단 선택
    1. 1단
    2. 2단
    3. 2단 2단시작
    4. 제목박스밑 가로

  - page_template with box template
  - page thumb, show selected
  
2018-11-20
  - 1면 4단 광고 우즉 여백

2018-11-19
  - image bottom and announcement  body_leading = 4pt
  - add 4단 section template
  
  - overflow bug when image is placed 
  - save xml
  - 9단 21 글자 밀어내기 over_lopping_box
  - 문체매인 1면 top
  - fix page svg codinate
  - title column_number

2018-11-12
  - add boxed_subtitle
    - add boxed_subtitle menu
  - add image fit type

2018-11-09
  - 박스문 추가
    본문박스(고딕_회색)
    본문박스(고딕_테두리)
    박스문 삭제
    ----
    안내문


  - image detail mode
  - image zoom, move, direction

  - section 
    - delte link to 6, 7, 
    - download_csv

2018-11-07

  - image change
      change image only without deleting captions and everyting else
      just change the image with same setting

  - expand when sybling is image

2018-11-07
  - update change made in issue
    - change page_template
    - set color to green if we have page
    - do not show create page once it is generated
  - subtile style
      고딕 보까시 박스
      스타일 추가 subtitle_s_gothic
      cmyk k=10
      테두리 0.3
      고딕_회색바탕
      고딕_테두리
  - image position 0
  - image position 7,8,9 fix it to align to bottom
  - working_article has_many_graphics
    - graphic uploader
    - tab for graphic uploader view

    - graphic no frame


2018-11-06
  - fix caption source right margin
  - image_grid_x position, - image_grid_y position,
  - update front_page_heading templates with ad_box in layout_rb
    - make image name as heading_ad.pdf
  - fix box_size changing bug
  - fix parsing article in Section, parsing ad as article

2018-11-05
  - add subject_head_S to text_style.yml
  - upload more than one image
  - update page_heading template with frontpage_ad with 
  - 9단21 홀/짝 ad_type
  - page_template thumbnail with box with number
  - mark current article with yellow

2018-11-01
  - fix caption_column last caption line align to left
  - page view template, show only the templates with current ad_type
  - front_page ad upload 돌출광고
  - fix bug when changing page template
  - fix working_article order
  

2018-10-31
  - announcement 안내문 
    - 안내문 붉은색 20, 100, 50, 10
    -            100, 50, 0, 10
    - 14, 9.6, < > 
  - view page template by category

  

2018-10-30
  - fix right side text cut off

2018-10-26
  - 5단면 지원
  - 안내문 모델
    - announcement_text
    - announcement_column
    - announcement_color
  - announcements table
    - name
    - kind
    - title
    - subtitle
    - column
    - lines
    - color
    - page
    - script

2018-10-23
  - add for_first_page:boolean to story
  - add sidekiq worker
  - fix assign_story_to_working_article

2018-10-22
  - fix slug for working_article
  - add sidekiq worker
  - fix assign_story_to_working_article

2018-10-11
  - 18면 전면광고 시 면머리 교쳬
  
   
2018-10-9
  - fix issue page view grouping from page_range to section_name based
  - fix story assignment
    - based on group, not page
    - return to story group with session saved into
    - add change story to working article
    - show working_article with story with different color in story assignment

2018-10-8
  - fix editorial_with_profile_image so that it can also be on any page, not just 23
  - change personal_image to has_profile_image:boolean
    this should tell whether or not to place person image

2018-10-6
  - add 6 column editorial
  - add 2 column opinion

2018-10-5
  - fix change_page_template
    - fix new attribute
    - let page refresh with generate_pdf_with_time_stamp

2018-10-3
  - assing story to working_article
  - add Sidekick
  - add issue story menu
  
2018-10-2
  - add datatable 
    - for story view

  - fix mobile preview xml merge
  - add article number to page svg
  - add story in menu

2018-9-30
  - fix edit color_page
  - upload page_heading image for first_page
  
2018-9-29
  - add Story model
  - in seed
    - add reporters as User 
    - do not regenerate working_article pdf unles when it is missing



2018_9_26
  - page_plan view with two pairing column
  - mobile xml preview merge
  - image crop with zoom and shifting
  - use ActiveStorage
  - use RSpec features spec
  - connect with naeil_cms

2018_9_25
  add extra fields to model, in order to avoid fetching parent models, so not to do n+1 fetching
  - page
      add_column :pages, :publication_id, :integer
      add_column :pages, :path, :string
      add_column :pages, :date, :date
      add_column :pages, :grid_width, :float
      add_column :pages, :grid_height, :float
      add_column :pages, :lines_per_grid, :float
      add_column :pages, :width, :float
      add_column :pages, :height, :float
      add_column :pages, :left_margin, :float
      add_column :pages, :top_margin, :float
      add_column :pages, :right_margin, :float
      add_column :pages, :bottom_margin, :float
      add_column :pages, :gutter, :float
      add_column :pages, :article_line_thickness, :float

  - section
      add_column :sections, :path, :string
      add_column :sections, :grid_width, :float
      add_column :sections, :grid_height, :float
      add_column :sections, :lines_per_grid, :float
      add_column :sections, :width, :float
      add_column :sections, :height, :float
      add_column :sections, :left_margin, :float
      add_column :sections, :top_margin, :float
      add_column :sections, :right_margin, :float
      add_column :sections, :bottom_margin, :float
      add_column :sections, :gutter, :float
      add_column :sections, :page_heading_margin_in_lines, :integer
      add_column :sections, :article_line_thickness, :float

  - article
      add_column :articles, :publication_name, :string
      add_column :articles, :path, :string
      add_column :articles, :page_heading_margin_in_lines, :integer
      add_column :articles, :grid_width, :float
      add_column :articles, :grid_height, :float
      add_column :articles, :gutter, :float

  - working_article
      add_column :working_articles, :publication_name, :string
      add_column :working_articles, :path, :string
      add_column :working_articles, :date, :date
      add_column :working_articles, :page_number, :integer
      add_column :working_articles, :page_heading_margin_in_lines, :integer
      add_column :working_articles, :grid_width, :float
      add_column :working_articles, :grid_height, :float
      add_column :working_articles, :gutter, :float

  - ad_box 
      add_column :ad_boxes, :path, :string
      add_column :ad_boxes, :date, :date
      add_column :ad_boxes, :page_heading_margin_in_lines, :integer
      add_column :ad_boxes, :page_number, :integer
      add_column :ad_boxes, :grid_width, :float
      add_column :ad_boxes, :grid_height, :float
      add_column :ad_boxes, :gutter, :float


2018_9_20

  - edit page_heading_text
  - put underline in page_heading_text
  - issue page_plan

  - change UI
  - Image Trimming
  - multiple image upload in one article

  - fix ad_group_oages
  - put ENV for sending FTP and print PDF

  - allow title and subtle with break at return

  - send PDF to Dropbox when pdf is send to Printer

  - save mobile xml

2018_9_19
  - update_working_articles
      generate_pdf or copy  after create
      generate page_pdf, refresh web page

  - Add Spread Model
    - issue view
    - spread_page_heading

2018_9_17
  - fix holyday
  - fix copy_heading in page.rb
  - replace mobile_xml_partials

2018_9_14
  - add rake tasl set_color_page
  - fix sending color page to print
  - fix sending color page to for ebiz

2018_9_13
  - page_plan
    - add more ad names
    - for page template display only temolates with same ad_type

2018_9_12
  - page 마감
    - add it to Dropbox with version number
    - add poof_version
    - add print_count
  - Print Monitoring
  - edit page_plan
    - pair_page
    - 광고주

  - when page template changed to full page ad page_heading text should changed to 

2018_9_12
  - fix page slug
      add page_number when creating page in issue
  - fix ad_box no line around
  - fix article no_top line


2018_9_3
  - 이미지 문페
  - 특집 박스조판
    - 외교국제
    - 기획
    - 도서

2018_9_2
  - 오늘 사용 광고 올리기
  - 오늘 사용 광고 라이브러리에 저장하기
  - 광고 저장된 광고 오늘 광고로 사용하기

  - change AdImageUploader to AdBoxImageUploader
      ad_image and ad_box for the current issue
      store it at publication/1/issue/ad/
      9-0_company_date.pdf
      9-0_samsung_2018-9-2.pdf
      parse file name and create ad_box and ad_image
  - create AdImageUploader
      ad_image for the publication
      store it at publication/ad/
      company_date.pdf
      samsung_2018-9-2.pdf

      parse file name and create ad_image

2018_8_31
  - fix line_space of subtitle after two lines

2018_8_28
  - add color field to ad_box table
  - add color field to ad_image table
  - remove
  #  page_number    :integer
  #  article_number :integer


2018_8_23
  - fix working_article to edit top_story fieid
  - fix page 10 template 2
  - fix crashing when image size is larger than article box

2018_8_20

  - fix single line body indent and text_alignment
  - use page_heading title from issue_plan
    - section grouping using page_heading

  - ad image, ad auto place
  - postgres db backup
  - ad auto placement
  - save ad data

2018_8_18
  - CMYK not for eps, pdf
  - fix page_heading section grouping

  - assign_reporters to working_article

2018_8_8

2018_8_2
  - display overflowing article box with red_line
  - prevent from sending to printer, if page has an overflowing article
  - give edit privilege only to certain user   

  - ad upload
  - ad auto placement at certain time

  - cms reporter page leader summit

2018_7_26
  - split_article
  - add PageSplitable, SectionSplitable, ArticleSplitable
  - add layout field to working_articles db

2018_7_24
  - fix working_article when kins =='사진'
    - show should have image info edit
    - generate article pdf when image is updated
    - remove link to image_edit when in 사진 모드
    - call generate_pdf_with_time_stamp when updating image with working_article_id

2018_7_20
  - friendly_id

2018_7_19
  - add whenever
  - add holidays.yml
  - fix sending pdf to printer to handle revisions

2018_7_16
  - fix page update_working_articles for extended_line_count and pushed_line_count

2018_7_13
  - new issue
    - validates uniqueness of issue.date
    - show previous_date
    - fix extended_line_count to template
      - new migrate add field to article
          add extended_line_count :integer
          add pushed_line_count   :integer
      - fix update working_article in page

    - rake new_issue
      - holidays.yml
          2018-1-1
          2018-3-1
          2018-8-15
          2018-10-10

2018_7_12
  - fix extended_line_count to increase relative to current value

2018_7_5
  - Ad db
      - upload ad with page_number
      - input advertiser, ad_type
  - db backup
  - print status
  - lock finished issues
  - pretty_url
  - sending revised pdf version to printer with different name


2018_7_2
  - when body text is one line, no first line indent applies
  - double quote at line ending bug
  - when sending pdf to print, make different named file

2018_7_1
  - no top line on working_article other than 22, 23
    - custom stroke_sides
  - image at the bottom position with article bottom_margin

2018_6_21
  - wire_story
    send_date
    content_id
    category_code
    category_name
    region_code
    region_name
    credit
    source
    title
    body

  - wire_image

2018_6_10
  - fix euc-kr bug
  - fix article initial kind as '기사'

2018_6_8
  - add char_count to article and working_article
  - show char_count in SVG
  - add smart quote filter to quote text

2018_6_7
  - fix ad_box to apply time_stamp
  - add scrape_gw

2018_6_6
  - fuzzy find ransack for opinion and profile
  - frendly_url

2018_6_5
  - Date.strftime("%d%m%y")
  - fix generate_layout for opinion
  - add opinion_jpg_image
  - add profile_jpg_image
  - add name= for opinion name

  newsman
  - align left overflow text
  - forbidden_first_chars
  - forbidden_last_chars
  - fix underflow text line count with news_image at page 22 order 2

2018_5_28
  - set '기사' as default working_article kind
  - fix delete_old_files for time_stamp
  - make high resolution jpg preview
  - add sending print files to dong_a and jung_ang

2018_5_26
  - add image_box menu on working_article
    - 1x1, 2x2, 3x3, 4x4,
    - top_right, top_left, top_center
    - middle_left, midle_center, middle_right
    - bottom_left, bottom_center, bottom_right

  - in the image panel
    - zoom_10%
    - zoom_20%
    - zoom_30%
    - move_right_10&
    - move_left_10&

2018_5_25
  - fix seven_column, six_column scope pg error

2018_5_23
  - add same_group_pages to page
  - redesign UI

2018_5_21
  - add same_group_pages to page

2018_5_21
  - add category_code to profile

2018_5_17
    - add category_code to working_article, reporter_group, opinion_writer
    - generate_pdf with time_stamp to force page reloading
    - article without page heading space or exteneded_line space
    - web scrape issue_plan

2018_5_10
  - add draw_divider to section
  - fix section config to save draw_divider
  - fix section.csv put page_number at first column
  - add botomm_box? to article and save botomm_box in layout_rb

2018_5_10
  - no subtile in editorial article
  - subject_head_s

2018_5_8
  - eager loading
  - run pg in production
  - add send pdf for proof reading
  - create xml

2018_5_7
  - handle forbidden at the beginning characters. . , ! ?
    - fix align token at the last line
  - chosun font not copying in PDF
    - make new font as Shinmoon.ttf

2018_5_5
  - change page to full page ad page with heading as 전면광고
  - add order field to AdBox

2018_5_4
  - move ad_image to ad_box, get rid of ad_image model
  - fix ad_image upload
  - add save_story_xml
  - remove image and ad_image from navigation bar menu
  - add pdf to ad_image uploader type
  - add previous issue_number to new issue

  - change sqlite to pg
  - eager loading


2018_5_3
  - save character_count_data
  - fix text_style, so that designers can edit

2018_5_1
  - add bottom_article?(article) method to Page
  - draw bottom_line only when draw_bottom_line and bottom_article is true
  - upload opinion_image
    - download csv
  - upload profile_image
    - download csv

2018_4_29
  - when we create new issue, make sure section pdf is generated only once
  - show quote_box_size
  - install postgres
  - opinion image uploaded
  - profile image uploaded

2018_4_26
  - place fixed ad in Section

2018_4_25
  - opinion image uploaded
    download csv
  - reporter similar to opinion
    download csv
  - fix ad image upload
    - handle EPS upload without imagemagick

2018_4_23
  - opinion image image_fit_to to horizontal

2018_4_22
  - fix image fit_type for opinion image to IMAGE_FIT_TYPE_KEEP_RATIO
  - show message after line change, quote_box size change, swap
2018_4_21
  - show character_count for working_article
  - add - extended_line_count, pushed

2018_4_20
  - fix overflow text
  - fix bug when changing template with extended lines not clearing
  - extended, pushed
  - fix reduced, and pulled

2018_4_19
  - 전면광고 page_heading
  - opinion
    - quote_auto

  - editorial
    - box show overflow
    - line above text
  - update section_config
    draw_divider: true for page 22

2018_4_18
  - fix ad page_heading_margin_in_lines
  - change black color as cmyk color  
  - add quote_box_size field to db
  - quote_box
    - 자동생성
    - ----
    - 2x2
    - 2x3
    - 2x4
    - ----
    - 발문 삭제

    - top_margin    = 2 lines
    - bottom_margin = 2 lines
  - fix save pdf for print

2018_4_17
  - fix overflow text
  - add quote_box for opinion
    - add quote_bpx
    - remove quote_box
    - space only line for <br>?

2018_4_16
  - add zoom_preview
  - extended_line_count, pushed_line_count
  - swap story

2018_4_12
  - opinion_page
    - create overflow column
  - opinion_page with image

2018_4_11
  - fix page_heading
  - fix opinion add new generate rb

  - 발문 추가
  - 이미지 추가, adjust image to fit
  - size grow + 1, + 2, +3

  - row col for small screen for page view
  - fix 금칙 , . at begging of the line
  - 본문정리
    convert single line text to ##

2018_4_11
  - remove upload image to issue area from publication area

2018_4_9
  - change section#layout to Array
    - [0,0,3,3,'광고_5단통']
    - [0,0,3,3,'사설']
    - [0,0,3,3,'가고']
    - [0,0,3,3,'사진']

  - remove sample ad images from git repo
  - add imagemagick with brew

  - fix editorial title error
  - fix error when creating Article PDF

2018_4_6
  - fix editorial box bottom_line
    - editorial box personal profile and body line mismatch

  - s = body.gsub(/^\^/, "")
  - s = body.gsub(/(\n|\r\n)+/, "\n\n")

  - in seed file add text_style.yml copy to shared location
    - add text_style.yml to publication
  - add body menu in working_article auto paragraph to markdown convert, put extra empty line.
  - add default full page ad to new issue

  - 교정용(by second) by article
  - 인쇄용(by date)

2018_4_4
  - fix ## space above
  - add <br/> support
  - fix editorial margin

  - add save to Dropbox
  - place default ad
  - show menu by login role
  - adjust_size 크기_조절
  - adjust_body_size
  - copy_fit   욱여넣기


2018_4_3
  - remove c.md, remove unused filed up section template
  - extra line line for ##

2018_4_1

  - used style checking

  - 22, 기고 사진박스
    기본광고 자동 자동추가
    사진박스 올리기
    pdf file

  - 23, 내일시론 기자명
    기본광고 자동추가

  - - partial for opinion, editorial

  - add users to seed


2018_3_27
  - add Users with working section info
  - show section range
  - add space before for ## , fix bug at the last line
  - create default_issue and copy it when creating new issue
  - move default_issue_plan to publication/default_issue_plan.rb and and include it to git

2018_3_24
  - add tab on working_articles
    text-editor ace
    preview     annotatejs
    image_edit
    quote_box
    box_style

2018_3_21
  - add save_as_default in Page
  - fix bug when changing page template
    add profile and section_id
  - login window as root
  - make three navigation buttons
  - view page
  - heading erb
  - change heading/output.pdf to layout.pdf

2018_3_19
  - create non-publishing holidays
    issue_number generated according to holidays
    year date

2018_3_16
  - change output.pdf to story.pdf
2018_3_15
  - when creating new issue, copy page pdf and jpg
  - generate page heading with new data and issue number
  - we might need date to issue number table

2018_3_14
  - issue_info_for_cms => issue_info
  - add publication
  - navigation arrows
    - pre, up, next for page and article
  - for page 22, 23 don't show page template

2018_2_25
  - ## put space_before

2018_2_23
  - add search for OpinionWriter
    - use ransack
  - upload image to OpinionWriter
  - multiple image path extension support {eps, pdf, jpg}

2018_2_19
  - fix navbar, color, remove items
  - fix col-md-4 to handle col-sm-4
  - apply newly defined text_styles
  - add text_styles emphasis definition
        style, font, prefix, suffix, color, size

  - add opinion_writers CRUD

2018_2_19
  - auto-generate opinion writers profile

2018_2_14
  - add ReporterGroups table
  - add Reporters table
  - add ArticlePlan table

  - parse reporter_data.csv
  - add page_plan_show as assign_reporter

  - in PagePlan create_article_plans
        is not creating ArticlePlans
  - Article add word_count
      page_columns, column, row, front_page, top_story,s top_position, on_left_edge, on_right_edge

2018_2_13
  - add assign_reporter

2018_2_4
  - copy to or save to Sites/naeil/#{issue}/#{page} folder
  - when generating pdf save_layout unless File.exit?(layout_rb)

2018_1_18
  - story_assign
  - show article order in page view

2018_1_2
  - <br> support
  - ## support running_head
  - "◆ 보유세 카드 떠오르는 배경 =" with *my content*
  - strong emphasis support with **my content**
  - This is a
    line break.
  - support different title_main for page column and column
  - support different title for page column and column
  - section 22,23, and book review page heading
    - SVG to rlayout
    - Do not copy from template, generate it from Model  
  -  Do not save Article sample, just generate pdf, jpg
    - reduce installation size
  - install demo site, installation instruction
  - recovery scenario
  - 메인기사 선택 selection

2017_12_12
  - draw guide lines on top of page or top of article
  - set main article with selection  메인, 기사,
  - ignore orphan strategy, just truncate as it comes.
  - selectable main_article,
  - support editorial_title
  - support opinion_title

2017_12_10
  - rake update_text_style
  - install chosun and co-pub font at server
  - bold and ## markup support in news_article body
  - yaml_dump

2017_12_9
  - PageHeading bg uploading
  - add working_article locking and unlocking
    - add locked_by: user_id
  - increase_title_size_by:flaot
  - force_fit_title

2017_12_7
  - publication sample page with lines,
  -  fix Line Object
  - add 5 column page

2017_11_22
  - add browser gem to detect agent

2017_11_22
  - page_heading height
    front page, inner_page, opinion_page

2017_11_15
  - front page heading bg
  - image frame control

2017_11_14
  - change front page heading background
  - make front page heading background
  - upload front page heading ad

2017_11_13
  - NewsAdBox view
  - add image delete button

2017_11_11
  - NewsAdBox

2017_11_9
  - new table stroke_style
    - class_name
    - korean_name
    - stroke_yml

  - create stroke_style.yml to publication/style/text_style.yml
      - page_heading_margin_in_lines: [4,3]

      - news_article_box
          korean: 기사박스
          graphic: [0,0,0,1,0.3] #[left,top, right, bottom, thickness, color, type]
          news_heading:
          news_image:
            image: [0,0,0,1,0.3]
          quote
      - news_opinion_box
          korean: 오피니언박스
          graphic: [0,2,0,1,0.3]
      - news_editorial_box
          korean: 사설박스
          graphic: [1,6,1,1,0.3]
      - news_image_box
          korean: 이미지박스
          graphic: [1,6,1,1,6]
      - news_ad_box
          korean: 광고박스
          graphic: [1,1,1,1,0]
      - add eNews rethinking newspaper media
          - animated headline
          - reading text to speech


2017_11_30

2017_11_30
  - add news_view
    slid show of pages
    when clincked zoom in for article preview

2017_11_29
  - add opinion_writers
    - name
    - title
    - organization
    - position

2017_11_24
  - clone_page   별판생성
    add  clone_name to page

2017_11_28
  - upload bg_image for heading
  - create for guest_writer

2017_11_23
  - add zoom article view

2017_11_22
  - add different height for opinion page heading height

2017_11_9
  - 제목 3단 should have have space_before of 1 line, but it doesn't
  - file upload PDF rmagick can not render PDF for thumbnail
  - EPS support

2017_10_31
  create
    NewsBox < Container
    NewsArticleBox  < NewsBox
    NewsImageBox    < NewsBox
    NewsComicBox    < NewsBox
    NewsAdBox       < NewsBox

  handle bottom position
    draw line?
    leave a space at the bottom?

2017_10_23
  박스사진
    박스사진 하단 2행 여백 줄
    그램에만 테두리
    맨 윗줄이 아닐경우 위에 1행 여백
    left_edge, right_edge 적용

  만평
    만평은 테두리 있고/없고 0.3포인트
    만평 타이들로고
    작가이름(본문기자 이름 스타일 사용)
    left_edge, right_edge 적용

  판권 박스
    left_edge, right_edge 적용 없음

2017_10_18
  - 상단여백 1줄,  when v_position == center or bottom

2017_10_17
  - 사진위치 변경
    - 우쯕상단, 중간상당, ...
    - 하단 여백 적용

  - 그래픽 첨부
  - 부제 줄바꾸기 지원
  - 돌출광고
  - 제목 부제 사이즈 조절

2017_10_16
  - working article article kind tab or pill

2017_10_15
  - eNews
    search
    view page
    download pdf article
    download image from pdf article

2017_10_15
  - page reload for working_article
  - page reload for page

2017_10_7
    제목입력박스
      제목        # 여기제목                  
      부제목      ##
      문패       ###
      리딩       ####

    본문입력박스
      본문
      본문고딕    **내용**
      기자명      >
      관련기사    [관련기사 2면]

      테두리제목   #
      편집자주    ##
      중간제목    ###
      안내박스    ####

    발문입력박스(floating text_box)
      제목      #
      제목      ##
      발문      ###
      본문      

    사진_박스(floating text_box)
      사진설명제목  #
      사진설명     ##
      출처        ###

2017_10_7
    기사, 기고, 사설, 이미지_박스, 디자인박스

2017_10_7
  ## graphic_request #그래픽
    date              # 일시
    title             # 내용
    requester         # 의뢰자
    person_in_charge  # 작업자
    status            # 진행중, 완성
    description       # 비고

2017_10_7
  - add inactive field to WorkingArticle
    - this will allow us to keep unused articles as inactive, between template change.
  - add article_id to WorkingArticle
2017_10_7
  - fix switching page templates,
    - page_view_show
      - change_template_page_path
    - delete unused ad_boxes
    - show progress

  - add Trix WYSIWIG editor
    fix story.md to story.yml

    - 본문 중간제목 별도의 스타일
        앞 1 줄 적용
    - 본문 고딕은 inline emphasis 적용 **내용** to mean 본문고딕
    - fix style_guide text_style preview with our text system

  - editors note, 문패

2017_9_27
  - apply scale to text
  - apply custom text to body, caption, and title
  - create SectionHeading
  - SectionHeading.update_section_configs



2017_9_26
  - apply text_style from saved custom setting
  - subtitle apply new line with return key
  - fist page heading ad upload
      t.integer :page_id
      t.string :heading_ad
      mount_uploader :heading_ad, HeadingAdUploader
  - apply new page heading with AI file
  - fix title width with non-edge box

2017_9_25
  - redirect_to to page after uploading ad_image
    placed images are lost during switching page
  - trigger relayout of AdBox, and Page when uploading ad_image
  - fix bug in subtile bottom space
  - ad_box go_back button should link to page

2017_9_4
  - fix copy_section_template to page
      - not to delete the whole thing, but copy layout , config,
      - backup story files for difference story_number templates
  - make story_backup_folder on each page folder

  - add table, graphic
  - change section_pdf to section

2017_9_4
  - make page with SVG, and get rid of title links
  - paragraph input with single return

  - upload ad in AdBox, add upload in WorkingArticle
  - page_headings
  - batch place issue_images
  - batch place, issue_ads
  - fix it so for image position change
  - image zoom and pan

2017_9_1
  - replace all text with TtitleText
  - carrierwave thumbnail
      - set image directory
      - small image 100x100
      - place images with Flexbox
  - squeeze title
    - auto adjust overflowing title

2017_8_28
  - image caption
  - add source box to image edit
  - allow adjusting image size

2017_8_23
  - ad_width, ad_x, ad left_inset, right_inset

2017_8_22
  - fix issue_images
    - from issue_images link to edit , not show
    - delete image
      - return to issue_images after delete
    - color green, if placed_in_layout red if not
    - 기사창으로 이동, if placed_in_layout
    - return from image edit,
      to issue_image, if article is not assigned
      to article if assigned
  - working_article
      - show image, personal_image
      - add link to edit_image
  - fix issue_ad_images
  - fix x, width


2017_8_16
  - in article view add article type selection

  - pan_image
  - image_with_caption
  - title and subtitle squeeze to fit
  - make use custom paragraph for title, subtitle, and all other text.

2017_8_11
  - news issue

2017_8_9
  - 사진 및 부분 2행

  - width of image with gutter

  - 문패
    문패 : subject_head #
    두덩어리 문패

    사설항목
    사설제목
    기고제목

    editorial_head
    문패 : subject_head #
    사설항목: editorial_head #
    {종류: '기고'}
    {종류: '사설'} ,

  [0,1,4,3, {광고: '5단통'}]
  기사입력창에서 수정

    {종류: '사진'}
    {종류: '기고'}
    {종류: '사설'}

기사입력창에서 수정

2017_8_8
  - change issue_path_with_date, from id
  - page-plan switching page
    - fix ad_box not copying bug
  - smart quote

  - article_kind

  - create new issue

  - image_caption, image_title, image_pan,
    - image_upload
    - ad_upload
    - 사진 위치 bug
    - upload image


  - box style support
    border, bgcolor, grid_frame

  - new publication at 3002
    - banner_image

2017_8_3
  - spinning progress-bar while processing


2017-8-1
  - add article kind 'story', 'editorial'
  - add category heading, body, float

  - sinlge and double quote error in input box,
  - smart quote
  - add box_attributes
  - add unit in publication
  - draw_sides,
  - article_bottom_spaces_in_lines
  - draw_divider

2017-7-28
  - front_page_heading_height
  - inner_page_heading_height
  - article_bottom_spaces_in_lines
  - article_line_draw_sides
      bottom_full, bottom_columns, dividing_vertical
  - article_line_thickness
  - on_left_edge, on_right_edge

2017-7-26
  - save publication info
    /SoftwareLab/newsman/publication_name/text_style.yml
    /SoftwareLab/newsman/publication_name/publication_info.yml

2017-7-21
  - front page page_heading,
  - auto generate issue date
  - fix change page bug, delete previous article files

2017-7-17
  - add color
  - fix page update after article edit
  - fix page update after article edit

2017-7-14
  - add status to page_plan
    indication page updated status
    add button to update individual page

2017-7-13
  - create dynamic text_style definition for varying text_style
    give, col, row,
    {
      '1x3': 12,
      '2x3': 14,
      '4x15': 16,
      '5x15': 16,
      '6x15': 18,
    }

2017-7-13
  - t.text :box_attributes
  - t.string :graphic_attributes

  - t.string :markup
  - category heading 제목박스, body 본문, float 플롯트

2017-7-9
  - add markup
  - used in column
    subject_head_4_5_6
    subtitle_4_5_6
    subtitle_3
    subtitle_2
    subtitle_1

2017-7-7
  - add units in publication
    mm, inch, point

  - add 문페, 편집자_노트
    cation, caption_title

2017-7-6
  - fix Article, and WorkingArticle to use custom style by sending newsman article . -custom={publication.name}

2017-7-3
  - fix rlayout create_columns

2017-7-2
  - fix article and working_article gutter, left_margin, right_margin depending on the position
    - add on_left_edge
    - add on_right_edge

3017-7-1
  - save text_style_file at "/Users/Shared/SoftwareLab/newspaper/publication_name.yml"
  - add regenerate Section with custom style, so we can see the change taking effect.
  - save_current_text_styles

  - update how NewspaperSectionPage lays out article column width depending on the location and width

3017-6-29
  - add issue_plan to issue
  - create page_plan table
    - page_number
    - section_name
    - profile
    - column
    - row
    - story_count
    - ad_type
    - advertiser
    - color_page
    - issue_id

    - update paired color_page
  - default_issue_plan should have have just page_number and profile
  - we should parse it and fill in the information from it

3017-6-28
  - fix parsing issue plan error
  - treat ads similar to images, attaching it to working_article_box
  - parse_ad_images
  - add devise

  - fix left_margin, right_margin for NewsArticleBox column
    - left_margin should be 0 for first column
    - right_margin should be 0 for right most column

  - fix page_headings


2017-6-27
  - rename ad_image to ad_image
  - fix ad rlayout_rb as NewsAdBox < Container
  - create AdBox


2017-6-23
  - rename ad_image to ad_image
  - fix ad containing section, working_article
  - create working_article_box for ads

2017-6-22
  - make rails project portable
    - gitignore public/issue/*
    - rake regenerate setup
    - db:drop db:seed
  - use drop box for image, graphic and ads

2017-6-21
  - issue_plan
    면배열표
      date
      publication_id

  - page_plan
    issue_plan_id
    ad_type
    advertiser
    text_color
    article_count
    page_number
    template_id


2017-6-19
  - merge TexgStyle show and edit when layout is shown
  단락 스타일, 영문 단락 스타일
    no space in the name
    no 's in the name
    no - in the joining
    _ 통일 cross_head
  - running_head?, cross_head
  - editor's note  , editor_note
  - brand naming, 애드-브랜드명
  - 왼쪽, 오른쪽, 가운데, 양측정렬
  - add box_attributes to text_style
  - 그래픽 효과?, 단락 장식, 박스_디자인
  {fill_color: 'red', stroke_width: '1', stroke_color: 'pink', stroke_dash: [1,2,1,2]}
  - add 문패 sample
  - two subject_head_18, subject_head_14, subject_head_12
  - 문페 18, 14, 12

  - 5,6,7단 부터 문패18
  - 3,4단 부터 14
  - 2단 12
  - ## 본문고딕
  - ### 박스단락

2017-6-12
  - apply image to Article
      - regenerate articles
      - mark it as used_in_layout: true
      - regenerate pages
  - image_caption
  - image_frame 0.1
    - wrap frame line on image only
  - image upload
  - make title & subtitle size adjustable
  - image_file_name
    - add date
  - ad space above ad box
    - 1 line
  - {종류: '만평'}
  - section index sort by page and ad

2017-6-15
  - add ad_images

2017-6-8
  - name images with page-order-column_size.jpg
  - parse image
      1-1-2.jpg, 2-1-3.jpg,
  - add_image in controller
  - add_image view
  - add fields to image model
      t.integer :page_number
      t.integer :story_number
      t.boolean :landscape
      t.integer :issue_id
      t.integer :working_article_id

2017-6-7
  - custom CUSTOM_NEWSPAPER_STYLE


"CMYK=100,70,0,0,0"
"RGB=100,100,100,50"

black
white
yellow
cyan
magenta

#ffeedd

123456789abcdef

2017-6_7
  - image_template sample duplicate

2017-6_5
  - put buttons in single line
    - change button_to to link_to single line
    - class: "btn-group  btn-group-sm btn-warning"

  - new route
    - style_view
    - style_update

2017-6_2
  - font style
  -   tracking    = point
  -   scale       = 100%
  -   space_width = point

  - preload images in folder
  - image box
  - image resource folder
  - 통합데스트 대체 UI
    - file name convention, folder
    - change height_extra_line to extra_height_in_lines

2017-6_1
  - 광고 크기조절 내부 여백 줄이 보일 수 있도록
  - 광고 겹치는 부분 프롯으로 처리하기(overlapping_floats)
  - image size by grid_x, and lines for height
      3x2+3
  - has_many images
  - has_many overlapping_floats
  - has_many personal_images
  - has_many quotes

2017-5_30
  - fill_up_empty_lines

  - create filler_text for 6 page_columns

2017-5_29
  - save article_type
  - creating working_article
    - parse_story


2017-5_28
  - add show issue to show 24 pages
  - add show page



2017-5_25
  - add issue
  - add page



2017-5_25
  - add ad_type to section_config_hash

2017-5_24
  - heading image fit type no scale
  - front_page title 3 lines
  - front_page main 3 lines top position 3 lines


2017-5_20
  - show overflowing text
  - do reporter markup
      What if we can place reporter line in the middle of the empty space.
  - create add when parsing layout


2017-5-19
  - article
    NEWS_ARTICLE_FRONT_PAGE_EXTRA_HEADING_SPACE_IN_LINES = 1



  - section
    - copy ad template
    - fix ad name with space

    - display thumbnail view of SVG
    - SVG with victor gem
    - ad input not reflecting when parsing layout
    - profile not updating after first time.



2017-5-16

  - text_style view  
    title two lines
    subtitle two lines


  - section
    - make section path
      page/profile/order
    - section clone button
    - parse section csv

2017-5-15
  - body text too tight
  - fix text_area text size to 16
  - make all articles editable

  - page_header
  - add parsing picture type to  section layout


  - save layout as file name, unique identifier
    - profile/layout

2017-5-14
  - fix top_position not being reflecting error
  - draw bottom line without gap
  - fix single column article width error
  - 2 lines subtitle space after
  - puts tracking to body


2017-5-12
  - paper size
  - text_line_spacing, 행간
  - add text_style scale 장평
  - fix squeezing effect of article

2017-5-10
  - spacing
    - 2 lines at the bottom, one line at the top
  - line thickness , 0.3
  - tracking for body
  - add top_story, for first page, so we have 4 kinds, 0,1,2,3
  - 0 : middle articles
  - 1 : top_position articles
  - 2 : top_story top_position articles
  - 3 : top_story for first page articles

  - add constants
    - NEWS_ARTICLE_BOTTOM_SPACE_INLINES   = 2
    - NEWS_ARTICLE_TOP_LINE_SPACE         = 1
    - NEWS_ARTICLE_INE_THICKNESS          = 0.3
    - GRID_LINE_COUNT                     = 7

2017-5-10
  - add top_position field to indicate the article is at y==0
  - article templates are grouped into 3 kinds
    0: regular, 1: top_box, 2: top_stroy,
  - copy_articles
    - copy_page_head
    - fix NewSectionPage to merge page_heading

2017-5-4
  - top_story
    - selectable column width subtitle layout
    -
  - text_style preview with sample text

2017-5-3
  - add more fields in text_styles
    - add font
    - add text_line_spacing

2017-5-1
  - add image in Article
    - add_image, add_personal_image, add_quote
    - add_select_image
    - article with image preview in SVG

2017-4-20
  - fix section parse bug
  - add download_csv for text_styles, ad, section
  - generate more article samples
  - add page_columns to article
  - generate article samples for each page_columns, 7, 6

  - add more section samples in seed file.
  - calculate number of words or char or lines.
  - use difference font
  - add article editing

2017-4-28
  - add image_templates
  - parent_column
  parent_column
  - direction
  - size

  - column
  - lines
  - make subtile as text_area for line braking


2017-4-27
  - font leading value for title, subtile
  - ad for 7.5
  - bridge 14
  - add Image table
    - file_name,

2017-4-24
  - install Yoon font to server
  - add ace-rails
  - add kaminari
  - add carrierwawe

2017-4-19
  - add ad menu
  - validates presence of name, column, row, page_columns in section
  - validates presence of column, row , layout, publication_id in section
  - validates uniqueness of layout in section
  - profile, is_front_page, is synthesized, do don't show at edit
  - fix copy_articles
  - fix going back in section show, edit according to the column list

  - download pdf, section
  - download pdf, article

2017-4-18
  - regenerate pdf when updating section
  - issue heading, page_heading_height = 3
  - article type:top_box top_box
  - change is_front_page to is_front_page
  - pagination
  - localization
  - add ad table
  - add issue table

- 2017-4-16
  - fix size mismatching bug on PDF
  - generate section pdf
  - sub-menubar

- 2017-4-15
  - generate more article sample 4,5,6 rows sample
  - display 4,5,6

- 2017-4-14
  - add section
    - save config
    - generate_pdf


  - add article by columnxrow folder

- 2017-3-24
  - title style doesn't change align left last paragraph line
  - ad top_story field to Article
  - add Article more sample
    0. default
    1. image
    2. quote
    3. personal_image
    4. top_story
