# == Schema Information
#
# Table name: pages
#
#  id           :integer          not null, primary key
#  page_number  :integer
#  section_name :string
#  column       :integer
#  row          :integer
#  ad_type      :string
#  story_count  :integer
#  color_page   :boolean
#  profile      :string
#  issue_id     :integer
#  page_plan_id :integer
#  template_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Page < ApplicationRecord
  belongs_to :issue
  belongs_to :page_plan
  has_many :working_articles
  has_many :ad_boxes

  before_create :copy_attributes_from_template
  after_create :setup

  DAYS_IN_KOREAN = %w{일요일 월요알 화요일 수요일 목요일 금요일 토요일 }
  DAYS_IN_ENGLISH = Date::DAYNAMES

  def path
    "#{Rails.root}/public/#{issue.publication.id}/issue/#{issue.date.to_s}/#{page_number}"
  end

  def pdf_image_path
    "/#{issue.publication.id}/issue/#{issue.date.to_s}/#{page_number}/section.pdf"
  end

  def pdf_path
    "#{Rails.root}/public/#{issue.publication.id}/issue/#{issue.date.to_s}/#{page_number}/section.pdf"
  end

  def jpg_image_path
    "/#{issue.publication.id}/issue/#{issue.date.to_s}/#{page_number}/section.jpg"
  end

  def jpg_path
    "#{Rails.root}/public/#{issue.publication.id}/issue/#{issue.date.to_s}/#{page_number}/section.jpg"
  end

  def page_heading_path
    path + "/heading"
  end

  def page_headig_layout_path
    page_heading_path + "/layout.rb"
  end

  def publication
    issue.publication
  end

  def page_heading
    publication.page_heading(page_number)
  end

  def page_heading_width
    publication.page_heading_width
  end

  def page_heading_height
    if page_number == 1
      publication.front_page_heading_height
    else
      publication.inner_page_heading_height
    end
  end

  def isuue_week_day_in_korean
    date = issue.date
    DAYS_IN_KOREAN[date.wday]
  end

  def year
    date = issue.date
    date.year
  end

  def month
    date = issue.date
    date.month
  end

  def day
    date = issue.date
    date.day
  end

  def korean_date_string
    date = issue.date
    if page_number == 1
      "#{date.year}년 #{date.month}월 #{date.day}일 #{isuue_week_day_in_korean} (#{issue.number}호)"
    else
      "#{date.year}년 #{date.month}월 #{date.day}일 #{isuue_week_day_in_korean}"
    end
  end

  def self.update_page_headings
    Page.all.each do |page|
      PageHeading.generate_pdf(page)
    end
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    copy_section_template
  end

  def sample_ad_folder
    "#{Rails.root}/public/#{issue.publication.id}/ad"
  end

  def issue_ads_folder
    "#{Rails.root}/public/#{issue.publication.id}/issue/#{issue.date.to_s}/ads"
  end

  def ad_image_string
    ad = ad_images.first
    if ad
      ad_images.first.ad_image_string
    end
    ""
  end

  def save_issue_plan_ad
    if ad_type && ad_type != ""
      issue_ad_string = "#{page_number}_#{ad_type}"
      system "cd #{issue_ads_folder} && touch #{issue_ad_string}"
    end
  end

  def select_sample_ad
    Dir.glob("#{sample_ad_folder}/#{page_columns}#{ad_type}/*{.jpg,.pdf}").sample
  end

  def copy_sample_ad
    if ad_type && ad_type != ""
      sample = select_sample_ad
      basename = File.basename(sample)
      ad_name  = "#{page_number}_#{basename}"
      system "cp #{sample} #{issue_ads_folder}/ad_name"
    end
  end

  def section_template_folder
    "#{Rails.root}/public/#{issue.publication.id}/section/#{page_number}/#{profile}/#{template_id}"
  end

  def  fix_working_articles
    template_section = Section.find(template_id)
    layout = eval(template_section.layout)
    layout.each_with_index do |box, i|
      atts = {}
      atts[:page_id]  = self
      atts[:order]    = i + 1
      if box.length == 4
        target = WorkingArticle.where(atts).first_or_create
        target.column     = box[2]
        target.row        = box[3]
        target.is_front_page = (page_number == 1 ? true : false)
        target.top_story     = (i == 0 ? true : false)
        target.top_position  = false
        if box[1] == 0 && page_number != 1
          target.top_position  = true
        elsif box[1] == 1 && page_number == 1
          target.top_position  = true
        end
        if box[0] == 0
          target.on_left_edge = true
        end
        if box[0] + box[2] == column
          target.on_right_edge = true
        end
        target.save
      else
        #TODO we have non-article box, ad or something
        # since this is copyied form section template
        # we might not have to anything?
      end
    end
  end

  def update_working_articles
    section = Section.find(template_id)
    self.profile      = section.profile
    self.page_number  = section.page_number
    self.section_name  = section.section_name
    self.column       = section.column
    self.row          = section.row
    self.ad_type      = section.ad_type
    self.story_count  = section.story_count
    self.save
    # delete unused working_articles
    if working_articles.count > 0
      working_articles.each do |old|
        old.destroy
      end
    end
    # copy working_article from template_section
    current_working_articles = working_articles
    section.articles.each_with_index do |article, i|
      atts = article.attributes
      atts = Hash[atts.map{ |k, v| [k.to_sym, v] }]
      atts.delete(:id)
      atts.delete(:section_id)
      atts.delete(:created_at)
      atts.delete(:updated_at)
      atts[:page_id] = self.id
      atts[:order] = i + 1
      WorkingArticle.where(atts).first_or_create
    end


    # copy ad_box from template_section
    current_ad_articles = ad_boxes
    section.ad_box_templates.each_with_index do |ad, i|
      atts = ad.attributes
      atts = Hash[atts.map{ |k, v| [k.to_sym, v] }]
      atts.delete(:id)
      atts.delete(:order)
      atts.delete(:section_id)
      atts.delete(:created_at)
      atts.delete(:updated_at)
      current_ad = current_ad_articles[i]
      unless current_ad
        atts[:page_id] = self.id
        current_ad = AdBox.where(atts).first_or_create
      end
      current_ad.update(atts)
    end
    # evaled_layout = eval(template_section.layout)
    # evaled_layout.each do |box_rect|
    # layout = eval(template_section.layout)
    # layout.each_with_index do |box, i|
    #   atts = {}
    #   atts[:page_id]  = self
    #   atts[:column]   = box[2]
    #   atts[:row]      = box[3]
    #   if box.length == 4
    #     atts[:order]    = i + 1
    #     atts[:is_front_page] = (page_number == 1 ? true : false)
    #     atts[:top_story]     = (i == 0 ? true : false)
    #     atts[:top_position]  = false
    #     if box[1] == 0 && page_number != 1
    #       atts[:top_position]  = true
    #     elsif box[1] == 1 && page_number == 1
    #       atts[:top_position]  = true
    #     end
    #     if box[0] == 0
    #       atts.on_left_edge = true
    #     end
    #     if box[0] + box[2] == column
    #       atts.on_right_edge = true
    #     end
    #     #TODO find page_number, order,
    #     current_artcie_atts = {}
    #     current_artcie_atts[page_id: page_number]
    #     current_artcie_atts[order: i + 1]
    #     current_artcie = WorkingArticle.where(atts).first_or_create
    #     current_artcie.update(atts)
    #     # WorkingArticle.where(atts).first_or_create
    #   elsif box.length == 5 && ad_type
    #     puts "creating ad_boxpage number:#{page_number}"
    #     atts[:ad_type] = ad_type
    #     AdBox.where(atts).first_or_create
    #   end
    # end

  end

  def copy_section_template
    source = Dir.glob("#{section_template_folder}/*").first
    if source
      system("rm -r #{path}/*")
      system("cp -r #{section_template_folder}/ #{path}")
    else
      puts "No template in #{section_template_folder}"
    end
    update_working_articles
  end

  def change_page(new_section_template_id)
    new_section_template = Section.find(new_section_template_id)
    section_hash = new_section_template.attributes
    section_hash = Hash[section_hash.map{ |k, v| [k.to_sym, v] }]
    section_hash[:template_id] = new_section_template_id
    section_hash.delete(:id)
    section_hash.delete(:layout)
    section_hash.delete(:order)
    section_hash.delete(:is_front_page)
    section_hash.delete(:publication_id)
    section_hash.delete(:created_at)
    section_hash.delete(:updated_at)
    update(section_hash)
    update_page_layout
  end

  def update_page_layout
    copy_section_template
    generate_heading_pdf
    regenerate_pdf
  end

  def heading_height_in_pt
    if page_number == 1
      publication.front_page_heading_height_in_pt
    else
      publication.inner_page_heading_height_in_pt
    end
  end

  def generate_heading_pdf
    PageHeading.generate_pdf(self)
  end

  def generate_pdf
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section_pdf ."
  end

  def regenerate_pdf
    working_articles.each do |working_article|
      working_article.generate_pdf
    end
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section_pdf ."
  end

  def eval_layout
    eval(layout)
  end

  # other SectionTemplate choices for current page
  def other_choices
    Section.where(page_number: page_number).all
  end

  private

  def copy_attributes_from_template
    section = Section.find(template_id)
    self.profile      = section.profile
    self.page_number  = section.page_number
    self.section_name  = section.section_name
    self.column       = section.column
    self.row          = section.row
    self.ad_type      = section.ad_type
    self.story_count  = section.story_count
    true
  end

end
