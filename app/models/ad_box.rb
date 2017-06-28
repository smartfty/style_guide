# == Schema Information
#
# Table name: ad_boxes
#
#  id         :integer          not null, primary key
#  column     :integer
#  row        :integer
#  ad_type    :string
#  advertiser :string
#  page_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AdBox < ApplicationRecord
  belongs_to :page
  has_many  :ad_images
end
