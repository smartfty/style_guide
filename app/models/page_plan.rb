# == Schema Information
#
# Table name: page_plans
#
#  id                   :integer          not null, primary key
#  page_number          :integer
#  section_name         :string
#  selected_template_id :integer
#  column               :integer
#  row                  :integer
#  story_count          :integer
#  profile              :string
#  ad_type              :string
#  advertiser           :string
#  color_page           :boolean
#  dirty                :boolean
#  issue_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  description          :text
#  deadline             :string
#
# Indexes
#
#  index_page_plans_on_issue_id  (issue_id)
#
# Foreign Keys
#
#  fk_rails_...  (issue_id => issues.id)
#

# PagePlan is cewate with page_number and profile
# profile is parse to fill into info

class PagePlan < ApplicationRecord
  belongs_to :issue, optional: true
  has_one :page
  has_many :article_plans
  before_create :parse_profile
  after_create :create_article_plans

  def need_update?
    # check the dirty field and currnent page template id
    # we miught have a case where the use changes template back to the provious one
    # this cane we do npt need to update page
    return true unless page
    return false if page.template_id == selected_template_id
    dirty
  end

  def update_page
    page.change_template(selected_template_id) if page
  end

  def team_leader
    ReporterGroup.where(section: section_name).first.leader
  end

  def create_article_plans
    return if section_name == '전면광고'
    puts "story_count:#{story_count}"
    puts "profile:#{profile}"
    story_count.times do |i|
      ArticlePlan.where(page_plan:self, reporter: team_leader, order: i + 1, title: "제목은 여기에 ...").first_or_create
    end
  end


  def reporters_of_group
    group = ReporterGroup.where(section: section_name).first
    group.reporters if group
  end

  def pair_page
    page_count = issue.page_plans.count
    page_count - (page_number - 1)
  end

  def set_pair_page_color
    pair = PagePlan.find(pair_page)
    unless pair.color_page == color_page
      pair.color_page = color_page
      pair.save
    end
  end

  def set_pair_bridge_ad
    pair = PagePlan.find(pair_page)
    if pair.ad_type != "15단_브릿지" || pair.advertiser != advertiser
      pair.ad_type    = "15단_브릿지"
      pair.advertiser = advertiser
      pair.save
    end
  end

  def fix_profile_encoding(problem_profile)
    profile_array = problem_profile.split("_").last
    article_count = profile_array.last
    ad_type = profile_array[-2]

    if profile =~/^6x15/
      case article_count
      when '5'
        "6x15_광고없음_5"
      when '6'
        "6x15_광고없음_6"
      when '7'
        "6x15_광고없음_7"    
      when '8'
        "6x15_광고없음_8"
      when '9'
        "6x15_광고없음_9"
      when '10'
        "6x15_광고없음_9"
      when '11'
        "6x15_광고없음_9"
      end
    else
      case article_count
      when '5'
        "7x15_광고없음_5"
      when '6'
        "7x15_광고없음_6"
      when '7'
        "7x15_광고없음_7"    
      when '8'
        "7x15_광고없음_8"
      when '9'
        "7x15_광고없음_9"
      when '10'
        "7x15_광고없음_9"
      when '11'
        "7x15_광고없음_9"
      end
    end
  end

  private

  def parse_profile
    if profile && profile != ""
      puts "profile:#{profile}"
      puts "profile.length:#{profile.length}"
      ad_type = profile.split("_")[-2]
      puts "ad_type:#{ad_type}"
      selected_section_template = Section.where("section_name like ?", "%#{section_name}%").select{|s| ad_type == ad_type.ad_type}
      # selected_section_template = Section.where(section_name: section_name, ad_type: self.ad_type).take
      unless selected_section_template.class == Section
          selected_section_template = Section.where(page_number: page_number, ad_type: ad_type).first
      end
      unless selected_section_template.class == Section
        # eval an YAML::laod is not properly converting korean strings
        # "6x15_광고없음_9".length should give us 11, but it returns 18 
        # lets just put sample profile
        #TODO
        profile = fix_profile_encoding(self.profile)
        unless selected_section_template.class == Section
          if page_number.odd?
            selected_section_template = Section.where(page_number: 101, ad_type: ad_type).first
          else
            selected_section_template = Section.where(page_number: 100, ad_type: ad_type).first
          end
        end
      end
      unless selected_section_template.class == Section
        selected_section_template = Section.where(page_number: page_number).first
      end
      unless selected_section_template.class == Section
        puts "No section template for profile: #{profile} found!!! !!!"
        puts "using alternative template"
        selected_section_template = Section.where(ad_type: ad_type).first
        unless selected_section_template
          if page_number == 1
            selected_section_template = Section.where(page_number:1).first
          elsif page_number.odd?
            selected_section_template = Section.where(page_number: 101).first
          else
            selected_section_template = Section.where(page_number: 100).first
          end
          unless selected_section_template.class == Section
            puts "No section template for found!!!"
            binding.pry
            return false
          end
        end
      end
      self.selected_template_id = selected_section_template.id
      self.column               = selected_section_template.column
      self.row                  = selected_section_template.row
      self.story_count          = selected_section_template.story_count
      self.ad_type              = selected_section_template.ad_type
      self.dirty                = true
    else
      puts " no profile is given, so make a default page"
      return false
    end
    true
  end
end
