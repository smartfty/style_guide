# StyleGude

Rails app for creating style guide for newspaper publication

## Tables

### publication
  name
  paper_size
  width
  height
  left_margin
  top_margin
  right_margin
  bottom_margin
  lines_per_grid
  page_gutter
  gutter
  page_count
  section_names
  front_page_heading

### section
  profile
  column
  row
  ad_type
  is_front_page
  story_count
  page_number
  section_name
  layout
  color_page
  divider_position
  #--------
  issue_id

### ad
  name
  korean_name
  page_columns
  column
  row

### image_template
  parent_column:integer
  parent_row:integer
  column:integer
  row:integer
  height_adjustment_in_lines
  image_path
  caption
  caption_title
  position      # top_right, bottom_right, top_midddle, middle_middle, full_height

  <!-- top_offset_in_lines:integer
  bottom_offset_in_lines:integer -->
  profile
  parent_id:integer

### text_style
  reference
  name
  korean_name
  font
  size
  color
  tracking
  space_width
  scale
  space_before_in_lines
  text_height_in_lines
  space_after_in_lines

### article
  kind
  column
  row
  title
  subtitle
  body
  reporter
  personal_image
  image
  quote

## page_heading
  page_number
  section_name
  layout
  publication

## issue
  references:publication
  issue_number:integer
  date: date

## page
  page_number
  section_name
  ad_type
  story_count
  column
  row
  is_front_page
  profile
  color_page

  issue_id
  template_id

## working_article
  t.integer :column
  t.integer :row
  t.integer :order
  t.integer :profile
  t.string :title
  t.string :subtitle
  t.text :body
  t.string :reporter
  t.string :email
  t.string :personal_image
  t.string :image
  t.string :quote
  t.string :name_tag
  t.boolean :is_front_page
  t.boolean :top_story
  t.boolean :top_position
  t.string :kind
  t.integer :page_columns
  t.references :issue, foreign_key: true

# email based layout?
  references:issue
  template_id:integer


TO: publication_name@naeil.design
subject: 3x4

---
title: title of Article
subtitle: subtitle of Article
___

body text goes here.
