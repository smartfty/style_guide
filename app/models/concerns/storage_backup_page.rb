# frozen_string_literal: true

module StorageBackupPage
  extend ActiveSupport::Concern

  def move_carrierwave_images_to_storage
    working_articles.each(&:move_carrierwave_images_to_storage)
    ad_boxes.each(&:move_carrierwave_images_to_storage_for_ad)
  end
end
