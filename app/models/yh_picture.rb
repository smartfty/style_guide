# == Schema Information
#
# Table name: yh_pictures
#
#  id              :bigint(8)        not null, primary key
#  action          :string
#  service_type    :string
#  content_id      :string
#  date            :date
#  time            :time
#  urgency         :string
#  category        :string
#  class_code      :string
#  attriubute_code :string
#  source          :string
#  credit          :string
#  region          :string
#  title           :string
#  comment         :string
#  body            :string
#  picture         :string
#  taken_by        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class YhPicture < ApplicationRecord
  validates_uniqueness_of :content_id
  
    def sorce_path
      "/wire_source/201_PHOTO_YNA/20181010"
    end

    def full_size_path
      return unless picture
      full_size = picture.split(" ").first
      sorce_path + "/#{full_size}"
    end

    def preview_path
      return unless picture
      preview = picture.split(" ")[1]
      sorce_path + "/#{preview}"
    end

    def thumb_path
      return unless picture
      thumb = picture.split(" ").last
      sorce_path + "/#{thumb}"
    end

    def taken(user)
      self.taken_by = user.name
      self.save
    end

    def self.delete_week_old(today)
      one_week_old = today.days_ago(7)
      YhPicture.all.each do |picture|
        picture.destroy if picture.created_at < one_week_old
      end
    end
end
