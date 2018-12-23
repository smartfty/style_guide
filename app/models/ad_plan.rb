# == Schema Information
#
# Table name: ad_plans
#
#  id          :bigint(8)        not null, primary key
#  date        :date
#  page_number :integer
#  ad_type     :string
#  advertiser  :string
#  color_page  :boolean
#  comment     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AdPlan < ApplicationRecord
end
