# == Schema Information
#
# Table name: yh_photo_fr_ynas
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

class YhPhotoFrYna < ApplicationRecord
    validates_uniqueness_of :content_id
  
    def sorce_path
        require 'date'
        today = Date.today
        today_string = today.strftime("%Y%m%d")
        @filename_date = content_id.split("/").last.scan(/\d{3,8}/).first
        "/wire_source/205_PHOTO_FR_YNA/#{@filename_date}"
        # "/wire_source/203_GRAPHIC/20190424"
        # "/Volumes/211.115.91.190/101_KOR/#{Issue.last.date_string}"
        # "/Volumes/211.115.91.190/203_GRAPHIC/#{Issue.last.date_string}"
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
        YhPhotoFrYna.all.each do |photo_fr_yna|
            photo_fr_yna.destroy if photo_fr_yna.created_at < one_week_old
        end
    end
end
