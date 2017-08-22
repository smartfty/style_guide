# == Schema Information
#
# Table name: ad_images
#
#  id                 :integer          not null, primary key
#  ad_type            :string
#  column             :integer
#  row                :integer
#  image_path         :string
#  advertiser         :string
#  page_number        :integer
#  article_number     :integer
#  working_article_id :integer
#  issue_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#



class AdImage < ApplicationRecord
  belongs_to :issue
  belongs_to :ad_box, optional: true

  before_create :parse_ad
  mount_uploader :ad_image, AdImageUploader

  def image_path
    "#{Rails.root}/public" + image.url if image
  end

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

  def ad_image_string
    "#{page.page_number}_#{ad_type}"
  end

  private

  def parse_ad
    profile_array         = File.basename(ad_image.url).split("_")
    if profile_array[0] =~/^\d/
      page_number         = profile_array[0]
      self.page_id        = Page.where(issue_id: issue_id, page_number: page_number).first.id
      self.ad_type        = profile_array[1]
      self.advertiser     = profile_array[2]
    else
      puts "we have ad without page_number!!!"
    end
    true
  end

end
