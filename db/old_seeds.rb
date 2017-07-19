# require 'csv'
require 'yaml'
# gutter = 4.5mm = mm * 2.834646
section_names = [
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

p = Publication.where(name: '내일신문', paper_size: 'custom', width: 1116.85,  height: 1539.21, left_margin: 42.52, top_margin: 42.52, right_margin: 42.52, bottom_margin: 42.52, lines_per_grid: 7, divider: 25.51, gutter: 12.75, page_count:24, section_names: section_names, page_columns: [6,7]).first_or_create
# # # #

current_style_path = "/Users/Shared/SoftwareLab/newspaper_text_style/#{p.name}.yml"
current_style = YAML::load_file(current_style_path)
#
current_style.each do |atts|
    atts[:publication] = p
    TextStyle.where(atts).first_or_create
end
#
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
# quote           = "이부분이 이용한 부분입니다. 이부분은 본문 중간에 위치 하게 됩니다. 아마도 이부분이 좀던 눈에 띠게 해야 합나다."
# extra_paragraph = "\n#{quote}"*3

(6..7).to_a.each do |page_columns|
  (1..page_columns).to_a.each do |column|
    options                 = {publication: p,}
    options[:page_columns]  = page_columns
    options[:column]        = column
    options[:title]         = title
    options[:subtitle]      = subtitle unless column == 1
    options[:body]          = body
    if column == 5
      options[:body] += extra_paragraph
    elsif column == 6
      options[:body] += extra_paragraph*7
    elsif column == 7
      options[:body] += extra_paragraph*10
    end
    options[:reporter]        = reporter
    options[:email]           = email
    options[:top_story]       = false
    [2,3,4,5,6,7,8,9,10,11,12,13,14,15].each do |row|
      # normal article
      options[:row]             = row
      options[:kind]            = 0
      options[:top_position]    = false
      options[:is_front_page]   = false
      Article.where(options.dup).first_or_create

      # top_position for inner page
      options_1                 = options.dup
      options_1[:top_position]  = true
      options_1[:is_front_page] = false
      options_1[:kind]          = 1
      Article.where(options_1.dup).first_or_create

      # top_position for front page
      options_2                 = options.dup
      options_2[:top_position]  = true
      options_2[:is_front_page] = true
      options_2[:kind]          = 2
      Article.where(options_2).first_or_create

      # inner page top story
      options_3 = options.dup
      options_3[:top_story]     = true
      options_3[:top_position]  = true
      options_3[:kind]          = 3
      Article.where(options_3).first_or_create

      # front page top story
      options_4                 = options.dup
      options_4[:is_front_page] = true
      options_4[:top_story]     = true
      options_4[:top_position]  = true
      options_4[:kind]          = 4
      Article.where(options_4).first_or_create
    end
  end
end
#
# ad_csv_path = "#{Rails.root}/public/1/ad/ads.csv"
# csv_text = File.read(ad_csv_path)
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#   Ad.where(row.to_hash).first_or_create
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
# layout_index          = keys.index('layout')
#
# csv.each do |row|
#   row_h = Hash[keys.zip row]
#   row_h.delete(:profile)
#   # Member.create!(row.to_hash)
#   Section.where(row_h).first_or_create
# end


# issue = Issue.where(id: 1, date: Date.new(2017,5,30), number: '00001', publication_id: 1).first_or_create
# issue.parse_images
# issue.parse_ad_images
# issue.parse_graphics

#
# user1 = User.create(name: "Min Soo Kim", email: "mskimsid@gmail.com", password: 'itis1234', password_confirmation: "password", role: 3)
# user2 = User.create(name: "김형규", email: "hgkim@naeil.com", password: 'itis1234', password_confirmation: "password", role: 3)
# user3 = User.create(name: "양유미", email: "biny@naeil.com", password: 'itis1234', password_confirmation: "password", role: 3)
# user4 = User.create(name: "조경희", email: "khcho@naeil.com", password: 'itis1234', password_confirmation: "password", role: 2)
# user5 = User.create(name: "안성현", email: "shahn@naeil.com", password: 'itis1234', password_confirmation: "password", role: 2)
#
# user6 = User.create(name: "편집1", email: "editor1@naeil.com", password: 'itis1234', password_confirmation: "password", role: 1)
# user7 = User.create(name: "편집2", email: "editor2@naeil.com", password: 'itis1234', password_confirmation: "password", role: 1)
#
# user8 = User.create(name: "기자1", email: "reporter1@naeil.com", password: 'itis1234', password_confirmation: "password",)
# user9 = User.create(name: "기자2", email: "reporter2@naeil.com", password: 'itis1234', password_confirmation: "password",)
# user10 = User.create(name: "기자3", email: "reporter3@naeil.com", password: 'itis1234', password_confirmation: "password",)
