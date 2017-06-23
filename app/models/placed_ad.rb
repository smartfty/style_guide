# t.string :ad_type
# t.integer :column
# t.integer :row
# t.string :image_path
# t.string :advertiser
# t.integer :order
# t.integer :page_id
# t.integer :issue_id

class PlacedAd < ApplicationRecord
  belongs_to :issue
  belongs_to :page

  before_create :parse_ad

  def path
    "#{page.path}/ad"
  end

  def ad_info
    h               = {}
    h[:page_number] = page.page_number
    h[:ad_type]     = ad_type
    h[:advertiser]  = advertiser
    h
  end

  def ad_place_holder_string
    "#{page.page_number}_#{ad_type}"
  end


  def image_base_name
    File.basename(image_path)
  end

  def relative_path
    "/#{issue.relative_path}/ads/#{image_base_name}"
  end

  private

  def parse_ad
    profile_array         = image_basename.split("_")
    if profile_array[0] =~/^\d/
      page_number         = profile_array[0]
      self.page_id        = Page.where(issue_id: issue_id, page_number: page_number).first.id
      self.ad_type        = profile_array[1]
      self.advertiser     = profile_array[2]
      true
    else
      puts "we have ad without page_number!!!"
      false
    end
  end

end
