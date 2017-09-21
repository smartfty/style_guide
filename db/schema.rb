# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170630013933) do

  create_table "ad_box_templates", force: :cascade do |t|
    t.integer "grid_x"
    t.integer "grid_y"
    t.integer "column"
    t.integer "row"
    t.integer "order"
    t.string "ad_type"
    t.integer "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ad_boxes", force: :cascade do |t|
    t.integer "grid_x"
    t.integer "grid_y"
    t.integer "column"
    t.integer "row"
    t.string "ad_type"
    t.string "advertiser"
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_ad_boxes_on_page_id"
  end

  create_table "ad_images", force: :cascade do |t|
    t.string "ad_type"
    t.integer "column"
    t.integer "row"
    t.string "ad_image"
    t.string "advertiser"
    t.integer "page_number"
    t.integer "article_number"
    t.integer "ad_box_id"
    t.integer "issue_id"
    t.boolean "used_in_layout"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ads", force: :cascade do |t|
    t.string "name"
    t.integer "column"
    t.integer "row"
    t.integer "page_columns"
    t.integer "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.integer "grid_x"
    t.integer "grid_y"
    t.integer "column"
    t.integer "row"
    t.integer "order"
    t.string "kind"
    t.integer "profile"
    t.string "title_head"
    t.text "title"
    t.text "subtitle"
    t.text "subtitle_head"
    t.text "body"
    t.string "reporter"
    t.string "email"
    t.string "personal_image"
    t.string "image"
    t.text "quote"
    t.string "subject_head"
    t.boolean "on_left_edge"
    t.boolean "on_right_edge"
    t.boolean "is_front_page"
    t.boolean "top_story"
    t.boolean "top_position"
    t.integer "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer "column"
    t.integer "row"
    t.integer "extra_height_in_lines"
    t.string "image"
    t.string "caption_title"
    t.string "caption"
    t.string "source"
    t.integer "position"
    t.integer "page_number"
    t.integer "story_number"
    t.boolean "landscape"
    t.boolean "used_in_layout"
    t.integer "working_article_id"
    t.integer "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issues", force: :cascade do |t|
    t.date "date"
    t.string "number"
    t.text "plan"
    t.integer "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id"], name: "index_issues_on_publication_id"
  end

  create_table "page_headings", force: :cascade do |t|
    t.integer "page_number"
    t.string "section_name"
    t.string "date"
    t.text "layout"
    t.integer "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_plans", force: :cascade do |t|
    t.integer "page_number"
    t.string "section_name"
    t.integer "selected_template_id"
    t.integer "column"
    t.integer "row"
    t.integer "story_count"
    t.string "profile"
    t.string "ad_type"
    t.string "advertiser"
    t.boolean "color_page"
    t.boolean "dirty"
    t.integer "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_page_plans_on_issue_id"
  end

  create_table "pages", force: :cascade do |t|
    t.integer "page_number"
    t.string "section_name"
    t.integer "column"
    t.integer "row"
    t.string "ad_type"
    t.integer "story_count"
    t.boolean "color_page"
    t.string "profile"
    t.integer "issue_id"
    t.integer "page_plan_id"
    t.integer "template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_pages_on_issue_id"
    t.index ["page_plan_id"], name: "index_pages_on_page_plan_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "body"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publications", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.string "paper_size"
    t.float "width_in_unit"
    t.float "height_in_unit"
    t.float "left_margin_in_unit"
    t.float "top_margin_in_unit"
    t.float "right_margin_in_unit"
    t.float "bottom_margin_in_unit"
    t.float "gutter_in_unit"
    t.float "width"
    t.float "height"
    t.float "left_margin"
    t.float "top_margin"
    t.float "right_margin"
    t.float "bottom_margin"
    t.float "gutter"
    t.integer "lines_per_grid"
    t.integer "page_count"
    t.text "section_names"
    t.text "page_columns"
    t.integer "row"
    t.integer "front_page_heading_height"
    t.integer "inner_page_heading_height"
    t.integer "article_bottom_spaces_in_lines"
    t.text "article_line_draw_sides"
    t.float "article_line_thickness"
    t.boolean "draw_divider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.string "profile"
    t.integer "column"
    t.integer "row"
    t.integer "order"
    t.string "ad_type"
    t.boolean "is_front_page"
    t.integer "story_count"
    t.integer "page_number"
    t.string "section_name"
    t.boolean "color_page", default: false
    t.integer "publication_id", default: 1
    t.text "layout"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "text_styles", force: :cascade do |t|
    t.string "korean_name"
    t.string "english"
    t.string "category"
    t.string "font_family"
    t.string "font"
    t.float "font_size"
    t.string "text_color"
    t.string "alignment"
    t.float "tracking"
    t.float "space_width"
    t.float "scale"
    t.float "text_line_spacing"
    t.integer "space_before_in_lines"
    t.integer "space_after_in_lines"
    t.integer "text_height_in_lines"
    t.text "box_attributes"
    t.string "markup"
    t.text "dynamic_style"
    t.integer "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id"], name: "index_text_styles_on_publication_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "working_articles", force: :cascade do |t|
    t.integer "grid_x"
    t.integer "grid_y"
    t.integer "column"
    t.integer "row"
    t.integer "order"
    t.string "kind"
    t.string "profile"
    t.text "title"
    t.string "title_head"
    t.text "subtitle"
    t.string "subtitle_head"
    t.text "body"
    t.string "reporter"
    t.string "email"
    t.string "personal_image"
    t.string "image"
    t.text "quote"
    t.string "subject_head"
    t.boolean "on_left_edge"
    t.boolean "on_right_edge"
    t.boolean "is_front_page"
    t.boolean "top_story"
    t.boolean "top_position"
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_working_articles_on_page_id"
  end

end
