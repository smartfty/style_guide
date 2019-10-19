# frozen_string_literal: true

module StorageBackupWorkingArticle
  extend ActiveSupport::Concern

  def move_carrierwave_images_to_storage
    images.each do |image|
      filename = File.basename(URI.parse(image.image.url))
      image.storage_image.attach(io: open(image.image.url), filename: d.file)
    rescue StandardError => e
      ## log/handle your errors in order to retry later
    end
    graphics.each do |graphic|
      filename = File.basename(URI.parse(graphic.graphic.url))
      graphic.storage_graphic.attach(io: open(graphic.graphic.url), filename: d.file)
    rescue StandardError => e
      ## log/handle your errors in order to retry later
    end
  end

  # for ad_box
  def move_carrierwave_images_to_storage_for_ad
    # 이거는 기존 carrierwave 에서 가저 오는거니까
    #
    if ad_image.present?
      filename = File.basename(URI.parse(ad_image.url))
      storage_ad_image.attach(io: open(ad_image.url), filename: d.file)
    end
    # rescue StandardError => e
    #   ## log/handle your errors in order to retry later
    # end
  end
end
