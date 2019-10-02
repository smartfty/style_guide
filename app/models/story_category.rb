# == Schema Information
#
# Table name: story_categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StoryCategory < ApplicationRecord
    # belongs_to :story
    # belongs_to :working_article
    has_many :story_subcategory
    validates :name, :code, presence:true
    validates_uniqueness_of :name, :code
end
