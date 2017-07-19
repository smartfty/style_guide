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

p = Publication.where(name: '내일신문', paper_size: 'custom', width: 1116.85,  height: 1539.21, left_margin: 42.52, top_margin: 42.52, right_margin: 42.52, bottom_margin: 42.52, lines_per_grid: 7, divider: 25.51, gutter: 12.75, page_count:24, section_names: section_names, page_columns: [6,7]).first_or_create

section_names.each_with_index do |section_name, i|
  PageHeading.where(publication_id: p.id, page_number: i + 1, section_name: section_name, date: Date.new(2017,5,30)).first_or_create
end

current_style_path =  "#{Rails.root}/public/1/text_style/text_styles.csv"
csv_text = File.read(current_style_path)
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  h = row.to_hash
  h.delete('custom_font')
  TextStyle.where(h).first_or_create
end

ad_csv_path = "#{Rails.root}/public/1/ad/ads.csv"
csv_text = File.read(ad_csv_path)
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Ad.where(row.to_hash).first_or_create
end
puts "Ad.count:#{Ad.count}"


csv_path = "#{Rails.root}/public/1/section/sections.csv"
csv_text = File.read(csv_path)
csv = CSV.parse(csv_text)
keys  = csv.shift
keys.map!{|e| e.to_sym}
csv.each do |row|
  row_h = Hash[keys.zip row]
  row_h.delete(:divider_position)
  s = Section.where(row_h).first_or_create!
  # s.update_section_layout  if s
end

issue = Issue.where(id: 1, date: Date.new(2017,5,30), number: '00001', publication_id: 1).first_or_create
issue.parse_images
issue.parse_ad_images
issue.parse_graphics

user1 = User.where(name: "김민수", email: "mskimsid@gmail.com", password: 'itis1234', password_confirmation: "itis1234", role: 3).first_or_create
user2 = User.where(name: "김형규", email: "hgkim@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 3).first_or_create
user3 = User.where(name: "양유미", email: "biny@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 3).first_or_create
user4 = User.where(name: "한승희", email: "shhan@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2).first_or_create
user4 = User.where(name: "조경아", email: "kacho@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2).first_or_create
user5 = User.where(name: "안성현", email: "shahn@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2).first_or_create
user5 = User.where(name: "김순희", email: "shkim@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2).first_or_create

user6 = User.where(name: "편집1", email: "editor1@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 1).first_or_create
user7 = User.where(name: "편집2", email: "editor2@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 1).first_or_create

user8 = User.where(name: "기자1", email: "reporter1@naeil.com", password: 'itis1234', password_confirmation: "itis1234").first_or_create
user9 = User.where(name: "기자2", email: "reporter2@naeil.com", password: 'itis1234', password_confirmation: "itis1234").first_or_create
user10 = User.where(name: "기자3", email: "reporter3@naeil.com", password: 'itis1234', password_confirmation: "itis1234").first_or_create
