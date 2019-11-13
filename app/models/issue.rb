# == Schema Information
#
# Table name: issues
#
#  id             :integer          not null, primary key
#  date           :date
#  number         :string
#  plan           :text
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string
#
# Indexes
#
#  index_issues_on_publication_id  (publication_id)
#  index_issues_on_slug            (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (publication_id => publications.id)
#

require 'zip/zip'

class Issue < ApplicationRecord
  belongs_to :publication
  has_many  :page_plans, dependent: :delete_all
  has_many  :pages, -> { order(page_number: :asc) }, dependent: :delete_all
  has_one :spread, dependent: :delete
  has_many  :images
  accepts_nested_attributes_for :images
  has_many :ad_images
  accepts_nested_attributes_for :ad_images

  before_create :read_issue_plan
  after_create :setup
  validates_presence_of :date
  validates_uniqueness_of :date

  include IssueStoryMakeable
  include IssueGitWorkflow
  include IssueSaveXml

  def publication_path
    publication.path
  end

  def path
    publication_path + "/issue/#{date}"
  end

  def relative_path
    "#{publication_id}/issue/#{date}"
  end

  def default_issue_plan_path
    "#{Rails.root}/public/#{publication_id}/default_issue_plan.rb"
  end

  def set_color_page
    pages.each do |page|
      # puts page.page_number
      if page.page_number == 22 || page.page_number == 23 || page.page_number == 10
        page.color_page = false
      else
        page.color_page = true
      end
      page.save
    end
  end

  # this is used in issue_plan for selecting available ad_types for given page
  # array of arrays of ad_types
  def available_ads_for_pages
    page_ads = []
    24.times do |index|
      page_ads << Section.available_ads_for(index + 1)
    end
    page_ads
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    system "mkdir -p #{issue_images_path}" unless File.directory?(issue_images_path)
    system "mkdir -p #{issue_ads_path}" unless File.directory?(issue_ads_path)
  end

  DAYS_IN_KOREAN = %w{(일) (월) (화) (수) (목) (금) (토)}

  def issue_week_day_in_korean
    DAYS_IN_KOREAN[date.wday]
  end

  def date_string
    date.strftime("%Y%m%d")
  end

  def korean_date_string
    # "#{date.year}년 #{date.month}월 #{date.day}일 #{issue_week_day_in_korean} (#{number}호)"
    "#{date.month}월 #{date.day}일 #{issue_week_day_in_korean} #{number}호"
  end

  def section_path
    "#{Rails.root}/public/#{publication_id}/section"
  end

  def eval_issue_plan
    eval(plan)
    # YAML::load(plan)
  end

  def issue_images_path
    path + '/images'
  end

  def issue_ads_path
    path + '/ads'
  end

  def issue_ad_list_path
    path + '/ads/ad_list.yml'
  end

  def issue_info_for_cms
    {
      'id' => id,
      'date' => date.to_s,
      'plan' => plan
    }
  end

  def current_working_articles_hash
    # code
  end

  def request_cms_new_issue
    puts __method__
    # cms_address = 'http://localhost:3001'
    # puts "#{cms_address}/#{id}"
    # RestClient.post( "#{cms_address}/api/v1/cms_new_issue/#{id}", {'payload' => issue_info_for_cms})
  end

  def news_cms_host
    'http://localhost:3001'
  end

  def news_cms_head
    "#{news_cms_host}/update_issue_plan"
  end

  def make_default_issue_plan
    #plan
    # section_names_array = eval(publication.section_names)
    default_plans = eval(plan)
    default_plans.each_with_index do |page_array, i|
      page_hash = {}
      page_hash[:issue_id] = id
      # puts "page_hash[:section_name]:#{page_hash[:section_name]}"
      page_hash[:page_number]   = i + 1
      page_hash[:section_name]   = page_array[0]
      page_hash[:profile]       = page_array[1]
      page_hash[:color_page]    = page_array[2] if page_array.length > 2
      # binding.pry
      p = PagePlan.where(page_hash).first_or_create!
    end
  end

  def update_plan
    make_pages
    # parse_images
    # parse_ad_images
    # parse_graphics
  end
  
  def make_spread
    puts 'in make_spread'
    Spread.create!(issue_id: id)
  end

  def make_pages
    page_plans.each_with_index do |page_plan, i|
      if page_plan.page
        if page_plan.need_update?
          if page_plan.page.color_page != page_plan.color_page
            page_plan.page.color_page = page_plan.color_page
            page_plan.page.save
          end
          page_plan.page.change_template(page_plan.selected_template_id)
          page_plan.dirty = false
          page_plan.save
        end
        next
      else
        # create new page
        page_plan.page = Page.create!(issue_id: id, page_plan_id: page_plan.id, page_number:page_plan.page_number,  section_name: page_plan.section_name, template_id: page_plan.selected_template_id, color_page:page_plan.color_page)
        page_plan.dirty = false
        page_plan.save
      end
    end
  end

  def page_plan_with_ad
    list = []
    page_plans.each do |pp|
      list << pp if pp.ad_type
    end
    list
  end

  def ad_list
    list = []
    pages.each do |page|
      list << page.ad_info if page.ad_info
    end
    return false unless list.empty?
    list.to_yaml
  end

  def save_ad_info
    system("mkdir -p #{issue_ads_path}") unless File.directory?(issue_ads_path)
    File.open(issue_ad_list_path, 'w') { |f| f.write.ad_list } if ad_list
  end

  def parse_images
    Dir.glob("#{issue_images_path}/*{.jpg,.pdf}").each do |image|
      puts "+++++ image:#{image}"
      h = {}
      issue_image_basename  = File.basename(image)
      profile_array         = issue_image_basename.split('_')
      puts "profile_array:#{profile_array}"
      next if profile_array.length < 2
      puts "profile_array.length:#{profile_array.length}"
      # h[:image_path]        = image
      h[:page_number]       = profile_array[0].to_i
      h[:story_number]      = profile_array[1].to_i
      h[:column]            = 2
      h[:column]            = profile_array[2].to_i if profile_array.length > 3
      h[:landscape]         = true
      h[:caption_title]     = '사진설명 제목'
      h[:caption]           = '사진설명은 여기에 사진설명은 여기에 사진설명은 여기에 사진설명'
      h[:position]          = 3 # top_right 상단_우측
      # TODO read image file and determin orientaion from it.
      h[:used_in_layout]    = false
      h[:landscape]         = profile_array[3] if profile_array.length > 4
      h[:row] = if h[:landscape]
                  h[:column]
                else
                  h[:column] + 1
                end
      h[:extra_height_in_lines] = h[:row] * publication.lines_per_grid
      h[:issue_id] = id
      # h[:column]            = profile_array[2] if  profile_array.length > 3
      page = Page.where(issue_id: self, page_number: h[:page_number]).first
      puts "h[:issue_id]:#{h[:issue_id]}"
      puts "h[:page_number]:#{h[:page_number]}"
      unless page
        puts "Page: #{h[:page_number]} doesn't exist!!!!"
        next
      end
      working_article = WorkingArticle.where(page_id: page.id, order: h[:story_number]).first
      if working_article
        h[:working_article_id] = working_article.id
        puts "h:#{h}"
        Image.where(h).first_or_create
      # TODO: create symbolic link
      else
        puts "article at page:#{h[:page_number]} story_number: #{h[:story_number]} not found!!!}"
      end
    end
  end

  def parse_ad_images
    Dir.glob("#{issue_ads_path}/*{.jpg,.pdf}").each do |ad|
      h = {}
      h[:image_path]        = ad
      h[:issue_id]          = self
      AdImage.where(h).first_or_create
    end
  end

  def parse_graphics
    puts __method__
  end

  def ad_list
    list = []
    pages.each(&:ad_images)
  end

  def save_issue_plan_ad
    pages.each(&:save_issue_plan_ad)
  end

  def copy_sample_ad
    pages.each(&:copy_sample_ad)
  end

  def reset_issue_plan
    self.plan = File.open(default_issue_plan_path, 'r', &:read)
    save
    make_default_issue_plan
  end

  def prepare
    read_issue_plan
  end

  def spread_left_page
    puts "pages.count:#{pages.count}"
    return if pages.count == 0
    half = pages.count/2
    puts "half:#{half}"
    pages[half - 1]
  end

  def spread_right_page
    return if pages.count == 0
    half = pages.count/2
    pages[half]
  end

  private

  def read_issue_plan

    if File.exist?(default_issue_plan_path)
      self.plan = File.open(default_issue_plan_path, 'r'){|f| f.read}
      return true
    else
      puts "#{default_issue_plan_path} does not exist!!!"
      return false
    end
  end
end
