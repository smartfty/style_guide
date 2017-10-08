require 'csv'
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

h = {}
h[:name]                            = '내일신문'
h[:paper_size]                      = '신문대판'
h[:unit]                            = 'mm'
h[:width_in_unit]                   = 393  # 1114.02 pt
h[:height_in_unit]                  = 545  # 1544.88 pt
h[:left_margin_in_unit]             = 15   # 42.52
h[:top_margin_in_unit]              = 15   # 42.52
h[:right_margin_in_unit]            = 15   # 42.52
h[:bottom_margin_in_unit]           = 15   # 42.52
h[:gutter_in_unit]                  = 4.5  # 12.75
h[:lines_per_grid]                  = 7
h[:page_count]                      = 24
h[:section_names]                   = section_names
h[:page_columns]                    = [6,7]
h[:row]                             = 15
h[:front_page_heading_height]       = 10
h[:inner_page_heading_height]       = 3
h[:article_bottom_spaces_in_lines]  = 2
h[:article_line_draw_sides]         = [0,0,0,1]
h[:article_line_thickness]          = 0.3
#
p = Publication.where(h).first_or_create
#
section_names.each_with_index do |section_name, i|
  SectionHeading.where(publication_id:p.id, page_number: i + 1, section_name: section_name, date: Date.new(2017,5,30)).first_or_create
  # ph.generate_pdf
end

current_style_path =  "/Users/Shared/SoftwareLab/newsman/#{p.name}/text_style.yml"
styles = YAML::load_file(current_style_path)
styles.each do |k,v|
  value = v.dup
  value[:english] = k
  h = Hash[value.map{ |key, value| [key.to_sym, value] }]
  TextStyle.where(h).first_or_create
end

ad_csv_path = "#{Rails.root}/public/1/ad/ads.csv"
csv_text = File.read(ad_csv_path)
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Ad.where(row.to_hash).first_or_create
end

# parse section.csv
csv_path = "#{Rails.root}/public/1/section/sections.csv"
csv_text = File.read(csv_path)
csv = CSV.parse(csv_text)
keys  = csv.shift
keys.map!{|e| e.to_sym}
csv.each do |row|
  row_h = Hash[keys.zip row]
  row_h.delete(:divider_position)
  s = Section.where(row_h).first_or_create!
  s.create_articles if s
  # s.update_section_layout  if s
end
#

issue = Issue.where(id: 1, date: Date.new(2017,5,30), number: '00001', publication_id: 1).first_or_create
issue.make_default_issue_plan if issue

# #
user1 = User.create!(name: "김민수", email: "mskimsid@gmail.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
user2 = User.create!(name: "김형규", email: "hgkim@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
user3 = User.create!(name: "양유미", email: "biny@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
user4 = User.create!(name: "조경아", email: "kacho@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
user5 = User.create!(name: "안상현", email: "shahn@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
user6 = User.create!(name: "한승효", email: "shhan@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
user7 = User.create!(name: "반수희", email: "shban@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
user8 = User.create!(name: "이지혜", email: "jhlee@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
user8 = User.create!(name: "이세현", email: "shlee@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
user8 = User.create!(name: "지선미", email: "smjee@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)

user9 = User.create!(name: "편집1", email: "editor1@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 1)
user10 = User.create!(name: "편집2", email: "editor2@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 1)

user11 = User.create!(name: "기자1", email: "reporter1@naeil.com", password: 'itis1234', password_confirmation: "itis1234",)
user12 = User.create!(name: "기자2", email: "reporter2@naeil.com", password: 'itis1234', password_confirmation: "itis1234",)
user13 = User.create!(name: "기자3", email: "reporter3@naeil.com", password: 'itis1234', password_confirmation: "itis1234",)
