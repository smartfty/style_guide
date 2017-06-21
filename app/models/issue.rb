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
#

class Issue < ApplicationRecord
  belongs_to :publication
  has_many  :pages
  has_many  :images
  before_create :read_issue_plan
  after_create :setup


  def path
    "#{Rails.root}/public/#{publication_id}/issue/#{id}"
  end

  def relative_path
    "#{publication_id}/issue/#{id}"
  end

  def default_issue_plan_path
    "#{Rails.root}/public/#{publication_id}/issue/default_issue_plan.rb"
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    make_pages
  end

  def section_path
    "#{Rails.root}/public/#{publication_id}/section"
  end

  def eval_issue_plan
    eval(plan)
  end

  def issue_images_path
    path + "/images"
  end

  def issue_ads_path
    path + "/ads"
  end

  def issue_ad_list_path
    path + "/ads/ad_list.yml"
  end

  def make_pages
    eval_issue_plan.each_with_index do |page_hash, i|
      puts "page_hash:#{page_hash}"

      section = Section.where(page_number: i+1).sample
      if section
        section_hash = section.attributes
        section_hash = Hash[section_hash.map{ |k, v| [k.to_sym, v] }]
        puts "section.id:#{section.id}"
        section_hash[:template_id] = section.id
        section_hash[:issue_id] = id
        section_hash.delete(:id)
        section_hash.delete(:layout)
        section_hash.delete(:order)
        section_hash.delete(:is_front_page)
        section_hash.delete(:publication_id)
        section_hash.delete(:divider_position)
        section_hash.delete(:created_at)
        section_hash.delete(:updated_at)
        puts "++++++++++++++"
        puts "section_hash:#{section_hash}"
        p = Page.where(section_hash).first_or_create
      else
        puts "page_number: #{i + 1}"
        puts "++++++++++ no section template found for page:#{page_hash[:page_number]}"
      end
    end
  end

  def ad_list
    list = []
    pages.each do |page|
      list << page.ad_info if page.ad_info
    end
    return false if list.length > 0
    list.to_yaml
  end

  def save_ad_info
    system("mkdir -p #{issue_ads_path}") unless File.directory?(issue_ads_path)
    File.open(issue_ad_list_path, 'w'){|f| f.write.ad_list} if ad_list
  end

  def parse_ads
    Dir.glob("#{issue_ads_path}/*{.jpg,.pdf}").each  do |ad|

    end

  end

  def parse_images

    Dir.glob("#{issue_images_path}/*{.jpg,.pdf}").each  do |image|
      h = {}
      issue_image_basename  = File.basename(image)
      profile_array         = issue_image_basename.split("_")
      h[:image_path]        = image
      h[:page_number]       = profile_array[0]
      h[:story_number]      = profile_array[1]
      h[:column]            = 2
      h[:column]            = profile_array[2] if  profile_array.length > 3
      h[:landscape]         = true
      h[:caption_title]     = "사진설먕 제목"
      h[:caption]           = "사진설먕운 여기에 사진설명은 여기에 사진설명은 여기에 사진설명"
      h[:position]          = 3 #top_right 상단_우측
      #TODO read image file and determin orientaion from it.
      h[:used_in_layout]    = false
      h[:landscape]         = profile_array[3] if  profile_array.length > 4
      if h[:landscape]
        h[:row]             = h[:column]
      else
        h[:row]       = h[:column] + 1
      end
      h[:height_in_lines]   = h[:row] * publication.lines_per_grid
      h[:issue_id]          = self.id
      # h[:column]            = profile_array[2] if  profile_array.length > 3
      page = Page.where(issue_id: self, page_number: h[:page_number]).first
      working_article = WorkingArticle.where(page_id: page.id, order: h[:story_number]).first
      if working_article
        h[:working_article_id] = working_article.id
        Image.where(h).first_or_create
      #TODO create symbolic link
      else
        puts "article at page:#{h[:page_number]} story_number: #{h[:story_number]} not found!!!}"
      end
    end
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
