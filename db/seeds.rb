require 'csv'
require 'yaml'
# section_names = [
#   '1면',
#   '정치',
#   '정치',
#   '정치',
#   '행정',
#   '행정',
#   '전면광고',
#   '국제통일',
#   '전면광고',
#   '금융',
#   '전면광고',
#   '금융',
#   '금융',
#   '산업',
#   '산업',
#   '산업',
#   '산업',
#   '정책',
#   '정책',
#   '기획',
#   '기획',
#   '오피니언',
#   '오피니언',
#   '전면광고'
# ]
#
# h = {}
# h[:name]                            = '내일신문'
# h[:paper_size]                      = '신문대판'
# h[:unit]                            = 'mm'
# h[:width_in_unit]                   = 393  # 1114.02 pt
# h[:height_in_unit]                  = 545  # 1544.88 pt
# h[:left_margin_in_unit]             = 15   # 42.52
# h[:top_margin_in_unit]              = 20   # 56.69292
# h[:right_margin_in_unit]            = 15   # 42.52
# h[:bottom_margin_in_unit]           = 15   # 42.52
# h[:gutter_in_unit]                  = 4.5  # 12.75
# h[:lines_per_grid]                  = 7
# h[:page_count]                      = 24
# h[:section_names]                   = section_names
# h[:page_columns]                    = [6,7]
# h[:row]                             = 15
# h[:front_page_heading_height]       = 10
# h[:inner_page_heading_height]       = 3
# h[:article_bottom_spaces_in_lines]  = 2
# h[:article_line_draw_sides]         = [0,0,0,1]
# h[:article_line_thickness]          = 0.3
# h[:cms_server_url]                  = 'http:://localhost:3001'
#
# p = Publication.where(h).first_or_create
#
# section_names.each_with_index do |section_name, i|
#   SectionHeading.where(publication_id:p.id, page_number: i + 1, section_name: section_name, date: Date.new(2017,5,30)).first_or_create
# end
#
# current_style_path =  "/Users/Shared/SoftwareLab/newsman/#{p.name}/text_style.yml"
# styles = YAML::load_file(current_style_path)
# styles.each do |k,v|
#   value = v.dup
#   value[:english] = k
#   h = Hash[value.map{ |key, value| [key.to_sym, value] }]
#   TextStyle.where(h).first_or_create
# end
#
# ad_csv_path = "#{Rails.root}/public/1/ad/ads.csv"
# csv_text = File.read(ad_csv_path)
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#   Ad.where(row.to_hash).first_or_create
# end
#
# reporter_group_csv_path = "#{Rails.root}/public/1/reporter/reporter_groups.csv"
# csv_text = File.read(reporter_group_csv_path)
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#   ReporterGroup.where(row.to_hash).first_or_create
# end
#
# reporter_csv_path = "#{Rails.root}/public/1/reporter/reporters.csv"
# csv_text = File.read(reporter_csv_path)
# csv = CSV.parse(csv_text, :headers => true)
# current_section = ''
# csv.each do |row|
#   h = row.to_hash
#   h = Hash[h.map{ |key, value| [key.to_sym, value] }]
#   section = h.delete(:section)
#   if section && section != current_section
#     current_section = section
#   end
#   g = ReporterGroup.where(section: current_section).first
#   h[:reporter_group] =  g
#   Reporter.where(h).first_or_create
# end

opinion_writer_csv_path = "#{Rails.root}/public/1/opinion/data.csv"
csv_text = File.read(opinion_writer_csv_path)
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  h = row.to_hash
  h = Hash[h.map{ |key, value| [key.to_sym, value] }]
  puts h
  h[:publication_id] = 1
  OpinionWriter.where(h).first_or_create
end

# csv_path = "#{Rails.root}/public/1/section/sections.csv"
# csv_text = File.read(csv_path)
# csv = CSV.parse(csv_text)
# keys  = csv.shift
# keys.map!{|e| e.to_sym}
# csv.each do |row|
#   row_h = Hash[keys.zip row]
#   row_h.delete(:divider_position)
#   s = Section.where(row_h).first_or_create!
#   s.create_articles if s
# end
#
# SECTIONS = [
#   '1면',
#   '정치',
#   '행정',
#   '국제통일',
#   '금융',
#   '산업',
#   '정책',
#   '기획',
#   '오피니언',
# ]

#
# issue = Issue.where(id: 1, date: Date.new(2017,5,30), number: '00001', publication_id: 1).first_or_create
# issue.make_default_issue_plan if issue
#
# user1 = User.create!(name: "김민수", email: "mskimsid@gmail.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
# user2 = User.create!(name: "김형규", email: "hgkim@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
# user3 = User.create!(name: "양유미", email: "biny@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
# user4 = User.create!(name: "조경아", email: "kacho@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
# user5 = User.create!(name: "안상현", email: "shahn@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
# user6 = User.create!(name: "한승효", email: "shhan@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
# user7 = User.create!(name: "반수희", email: "shban@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
# user8 = User.create!(name: "이지혜", email: "jhlee@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
# user8 = User.create!(name: "이세현", email: "shlee@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
# user8 = User.create!(name: "지선미", email: "smjee@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
# user9 = User.create!(name: "편집1", email: "editor1@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 1)
# user10 = User.create!(name: "편집2", email: "editor2@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 1)
# user11 = User.create!(name: "기자1", email: "reporter1@naeil.com", password: 'itis1234', password_confirmation: "itis1234",)
# user12 = User.create!(name: "기자2", email: "reporter2@naeil.com", password: 'itis1234', password_confirmation: "itis1234",)
# user13 = User.create!(name: "기자3", email: "reporter3@naeil.com", password: 'itis1234', password_confirmation: "itis1234",)
