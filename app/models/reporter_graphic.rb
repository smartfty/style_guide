# == Schema Information
#
# Table name: reporter_graphics
#
#  id             :bigint(8)        not null, primary key
#  user_id        :bigint(8)
#  title          :string
#  caption        :string
#  source         :string
#  wire_pictures  :string
#  section_name   :string
#  used_in_layout :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_reporter_graphics_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class ReporterGraphic < ApplicationRecord
  belongs_to :user
  has_many_attached :uploads
  has_one_attached :finished_job 

  def self.graphic_from_wire(user, wire)
    s = ReporterGraphic.where(user_id: user.id, wire_pictures: wire.picture).first_or_create! 
    s.title           = wire.title
    s.caption         = wire.body
    s.source          = wire.source
    s.wire_pictures   = wire.picture
    s.save
  end

  #TODO
  def sorce_path
    "/wire_source/203_GRAPHIC/20190312"
  end

  def full_size_path
    return unless wire_pictures
    full_size = wire_pictures.split(" ").first
    sorce_path + "/#{full_size}"
  end

  #TODO fix this
  def full_size_full_path
    "#{Rails.root}/public" + "#{full_size_path}" 
  end

  def preview_path
    return unless wire_pictures
    preview = wire_pictures.split(" ")[1]
    sorce_path + "/#{preview}"
  end

  def thumb_path
    return unless wire_pictures
    thumb = wire_pictures.split(" ").last
    sorce_path + "/#{thumb}"
  end
  
end
