
# TODO
- make demo video
- make user manual
- ajaxify all pdf_generatoin
- enable ace editor

- paginate remote with kaminari
- add ransack for index search

## get record with unique field (:layout)
- Section.distinct.pluck(:layout)

- fill_up words for article template
- place ad
- place image
- issue_plan edit
- page_view with clickable page view
- use key to summit

  - name
  - publication_id

  - add path
  - parse svg and make pdf
  - page_headings
      - SVG to PDF

  - page_plan
  - short key
  - progress wheel

2017_9_21
  - trigger relayout of AdBox, and Page when uploading ad_image
  - fix bug in subtile bottom space
  - ad_box go_back button should link to page
  - fist page heading ad upload
  - article_box hover with css

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
  - t.string :dynamic_style

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
