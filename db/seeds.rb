require 'csv'
require 'yaml'
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
h[:top_margin_in_unit]              = 20   # 56.69292
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
h[:cms_server_url]                  = 'http:://localhost:3001'

p = Publication.where(h).first_or_create
p.copy_text_style_to_shared_location

section_names.each_with_index do |section_name, i|
  SectionHeading.where(publication_id:p.id, page_number: i + 1, section_name: section_name, date: Date.new(2017,5,30)).first_or_create
end

current_style_path =  "/Users/Shared/SoftwareLab/newsman/#{p.name}/text_style.yml"
styles = YAML::load_file(current_style_path)
styles.each do |k,v|
  value = v.dup
  value[:english] = k
  h = Hash[value.map{ |key, value| [key.to_sym, value] }]
  h[:graphic_attributes] = h[:graphic_attributes].to_s
  TextStyle.where(h).first_or_create
end

ad_csv_path = "#{Rails.root}/public/1/ad/ads.csv"
csv_text = File.read(ad_csv_path)
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Ad.where(row.to_hash).first_or_create
end

reporter_group_csv_path = "#{Rails.root}/public/1/reporter/reporter_groups.csv"
csv_text = File.read(reporter_group_csv_path)
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  ReporterGroup.where(row.to_hash).first_or_create
end

reporter_csv_path = "#{Rails.root}/public/1/reporter/reporters.csv"
csv_text = File.read(reporter_csv_path)
csv = CSV.parse(csv_text, :headers => true)
current_section = ''
csv.each do |row|
  h = row.to_hash
  h = Hash[h.map{ |key, value| [key.to_sym, value] }]
  section = h.delete(:section)
  if section && section != current_section
    current_section = section
  end
  g = ReporterGroup.where(section: current_section).first
  if g
    h[:group]     = g.section
  end
  h[:role]                  = 0
  h[:password]              = "itis" + h[:cell].split("-").last
  h[:password_confirmation] = h[:password]
  User.create!(h) unless User.where(email: h[:email]).first
end

opinion_writer_csv_path = "#{Rails.root}/public/1/opinion/data.csv"
csv_text = File.read(opinion_writer_csv_path)
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  h = row.to_hash
  h = Hash[h.map{ |key, value| [key.to_sym, value] }]
  h[:publication_id] = 1
  OpinionWriter.where(h).first_or_create
end

profile_csv_path = "#{Rails.root}/public/1/profile/data.csv"
csv_text = File.read(profile_csv_path)
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  h = row.to_hash
  h = Hash[h.map{ |key, value| [key.to_sym, value] }]
  h[:publication_id] = 1
  Profile.where(h).first_or_create
end

csv_path = "#{Rails.root}/public/1/section/sections.csv"
csv_text = File.read(csv_path)
csv = CSV.parse(csv_text)
keys  = csv.shift
keys.map!{|e| e.to_sym}
csv.each do |row|
  row_h = Hash[keys.zip row]
  # row_h.delete(:divider_position)
  s = Section.where(row_h).first_or_create!
  s.create_articles if s
  # if s.page_number == 22 || s.page_number == 23
  #   # puts "s.id:#{s.id}"
  #   # puts "s.layout:#{s.layout}"
  #   s.regerate_section_preview
  # end
end

SECTIONS = [
  '1면',
  '정치',
  '행정',
  '국제통일',
  '금융',
  '산업',
  '정책',
  '기획',
  '오피니언',
]


issue = Issue.where(id: 1, date: Date.new(2017,5,30), number: '00001', publication_id: 1).first_or_create
issue.make_default_issue_plan if issue

User.create!(name: "김민수", email: "mskimsid@gmail.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
User.create!(name: "김형규", email: "hgkim@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
User.create!(name: "양유미", email: "biny@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
User.create!(name: "안상현", email: "shahn@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
User.create!(name: "한승효", email: "shhan@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
User.create!(name: "반수희", email: "shban@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
# User.create!(name: "이지혜", email: "jhlee@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
User.create!(name: "지선미", email: "smjee@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
User.create!(name: "이동명", email: "leedongmyeong@gmail.com", password: 'itis1234', password_confirmation: "itis1234",)

title = "기사 제목은 여기에..."
body  = "여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다."
ReporterGroup.all.each do |group|
  users = User.where(group: group.section).all
  10.times do |i|
    user = users[i]
    Story.where(date: issue.date, user: user, group: user.group, title: title, body: body).first_or_create if user
  end
end