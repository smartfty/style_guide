class Profile < ApplicationRecord
  belongs_to :publication
  mount_uploader :ProfileImage, ProfileImageUploader

end
