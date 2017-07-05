
# PagePlan is cewate with page_number and profile
# profile is parse to fill into info

class PagePlan < ApplicationRecord
  belongs_to :issue
  before_create :parse_profile

  private

  def parse_profile
    if profile && profile != ""
      profile_array = profile.split("_")
      grid = profile_array[0].split("x")
      self.column = profile_array[0].to_i
      self.row = profile_array[1].to_i
      self.story_count = profile_array.last.to_i
      profile_array.shift
      profile_array.pop
      profile_array.shift if profile_array.include?('H')
      self.ad_type =  profile_array[0] if profile_array.length > 0
    else
      puts " no profile is given, so make a default page"


    end
    true
  end
end
