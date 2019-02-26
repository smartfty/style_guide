# == Schema Information
#
# Table name: reporter_images
#
#  id             :bigint(8)        not null, primary key
#  user_id        :bigint(8)
#  title          :string
#  caption        :string
#  source         :string
#  reporter_image :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_reporter_images_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class ReporterImage < ApplicationRecord
  belongs_to :user
  mount_uploader :reporter_image, ReporterImageUploader

  def self.story_from_wire(user, wire)
    s = Image.where(user: user, date: Issue.last.date).first_or_create! 
    s.title = wire.title
    s.save
  end
end
