
# PagePlan is cewate with page_number and profile
# profile is parse to fill into info

class PagePlan < ApplicationRecord
  belongs_to :issue
  has_one :page

  before_create :parse_profile

  def need_update?
    #check thir dirty field and currnent page template id
    # we miught have a case where the use changes template back to the provious one
    # this cane we do npt need to update page
    return true unless page
    return false if page.template_id == selected_template_id
    dirty
  end

  def update_page
    page.change_page(selected_template_id)
  end

  private

  def parse_profile
    if profile && profile != ""
      selected_section_template = Section.where(page_number: page_number, profile: profile).first
      unless selected_section_template
        selected_section_template = Section.where(page_number: page_number).frist
      end
      unless selected_section_template
        puts "Np section template for the page: #{page_number} found!!! !!!"
        return false
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
