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

ActiveRecord::Schema.define(version: 20180516223951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ad_box_templates", id: :serial, force: :cascade do |t|
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

  create_table "ad_boxes", id: :serial, force: :cascade do |t|
    t.integer "grid_x"
    t.integer "grid_y"
    t.integer "column"
    t.integer "row"
    t.integer "order"
    t.string "ad_type"
    t.string "advertiser"
    t.boolean "inactive"
    t.string "ad_image"
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_ad_boxes_on_page_id"
  end

  create_table "ads", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "column"
    t.integer "row"
    t.integer "page_columns"
    t.integer "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "article_plans", force: :cascade do |t|
    t.bigint "page_plan_id"
    t.string "reporter"
    t.integer "order"
    t.string "title"
    t.string "char_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_plan_id"], name: "index_article_plans_on_page_plan_id"
  end

  create_table "articles", id: :serial, force: :cascade do |t|
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

  create_table "graphic_requests", force: :cascade do |t|
    t.date "date"
    t.string "title"
    t.string "requester"
    t.string "person_in_charge"
    t.string "status"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "heading_ad_images", force: :cascade do |t|
    t.string "heading_ad_image"
    t.float "x"
    t.float "y"
    t.float "width"
    t.float "height"
    t.float "x_in_unit"
    t.float "y_in_unit"
    t.float "width_in_unit"
    t.float "height_in_unit"
    t.bigint "page_heading_id"
    t.string "advertiser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_heading_id"], name: "index_heading_ad_images_on_page_heading_id"
  end

  create_table "heading_bg_images", force: :cascade do |t|
    t.string "heading_bg_image"
    t.bigint "page_heading_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_heading_id"], name: "index_heading_bg_images_on_page_heading_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", id: :serial, force: :cascade do |t|
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

  create_table "issues", id: :serial, force: :cascade do |t|
    t.date "date"
    t.string "number"
    t.text "plan"
    t.integer "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id"], name: "index_issues_on_publication_id"
  end

  create_table "opinion_writers", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "work"
    t.string "position"
    t.string "email"
    t.string "cell"
    t.string "opinion_image"
    t.bigint "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_code"
    t.index ["publication_id"], name: "index_opinion_writers_on_publication_id"
  end

  create_table "page_headings", id: :serial, force: :cascade do |t|
    t.integer "page_number"
    t.string "section_name"
    t.string "date"
    t.text "layout"
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_plans", id: :serial, force: :cascade do |t|
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

  create_table "pages", id: :serial, force: :cascade do |t|
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
    t.string "clone_name"
    t.index ["issue_id"], name: "index_pages_on_issue_id"
    t.index ["page_plan_id"], name: "index_pages_on_page_plan_id"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.text "body"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "profile_image"
    t.string "work"
    t.string "position"
    t.string "email"
    t.bigint "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id"], name: "index_profiles_on_publication_id"
  end

  create_table "publications", id: :serial, force: :cascade do |t|
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
    t.string "cms_server_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reporter_groups", force: :cascade do |t|
    t.string "section"
    t.string "page_range"
    t.string "leader"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_code"
  end

  create_table "reporters", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "title"
    t.string "cell"
    t.bigint "reporter_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reporter_group_id"], name: "index_reporters_on_reporter_group_id"
  end

  create_table "section_headings", force: :cascade do |t|
    t.integer "page_number"
    t.string "section_name"
    t.string "date"
    t.text "layout"
    t.integer "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", id: :serial, force: :cascade do |t|
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
    t.boolean "draw_divider"
  end

  create_table "stroke_styles", force: :cascade do |t|
    t.string "klass"
    t.string "name"
    t.text "stroke"
    t.bigint "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id"], name: "index_stroke_styles_on_publication_id"
  end

  create_table "text_styles", id: :serial, force: :cascade do |t|
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
    t.text "graphic_attributes"
    t.integer "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id"], name: "index_text_styles_on_publication_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
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

  create_table "working_articles", id: :serial, force: :cascade do |t|
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
    t.boolean "inactive"
    t.integer "extended_line_count"
    t.integer "pushed_line_count"
    t.integer "article_id"
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quote_box_size"
    t.integer "category_code"
    t.index ["article_id"], name: "index_working_articles_on_article_id"
    t.index ["page_id"], name: "index_working_articles_on_page_id"
  end

  add_foreign_key "article_plans", "page_plans"
  add_foreign_key "heading_ad_images", "page_headings"
  add_foreign_key "heading_bg_images", "page_headings"
  add_foreign_key "issues", "publications"
  add_foreign_key "opinion_writers", "publications"
  add_foreign_key "page_plans", "issues"
  add_foreign_key "profiles", "publications"
  add_foreign_key "stroke_styles", "publications"
  add_foreign_key "text_styles", "publications"
end
