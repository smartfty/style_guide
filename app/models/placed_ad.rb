class PlacedAd < ApplicationRecord
  belongs_to :page

  def path
    "#{page.path}/ad"
  end

  def ad_info
    h               = {}
    h[:page_number] = page.page_number
    h[:ad_type]     = ad_type
    h
  end
end
