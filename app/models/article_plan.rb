# == Schema Information
#
# Table name: article_plans
#
#  id           :integer          not null, primary key
#  page_plan_id :integer
#  reporter     :string
#  order        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ArticlePlan < ApplicationRecord
  belongs_to :page_plan

  def reporters_of_group
    page_plan.reporters_of_group.map{|r| r.name}
  end
end
