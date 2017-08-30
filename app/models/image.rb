# == Schema Information
#
# Table name: images
#
#  id                 :integer          not null, primary key
#  column             :integer
#  row                :integer
#  extra_height_in_lines    :integer
#  image_path         :string
#  caption_title      :string
#  caption            :string
#  position           :integer
#  page_number        :integer
#  story_number       :integer
#  landscape          :boolean
#  used_in_layout     :boolean
#  working_article_id :integer
#  issue_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Image < ApplicationRecord
  belongs_to :issue
  belongs_to :working_article, optional: true
  mount_uploader :image, ImageUploader
  before_create  :set_default

  def image_path
    "#{Rails.root}/public" + image.url if image
  end

  def iamge_layout_hash
    h = {}
    h[:image_path]        = image_path
    h[:column]            = column
    h[:row]               = row
    h[:position]          = position
    h[:extra_height_in_lines]   = extra_height_in_lines
    h[:is_float]          = true
    h[:caption_title]     = caption_title
    h[:caption]           = caption
    h[:source]            = source if source
    h
  end

  # set current_article_id, if page_number and story_number is given
  def update_change
    return unless page_number
    return unless story_number
    current_article_id = working_article_id
    page        = Page.where(issue_id: issue_id, page_number: page_number).first
    unless page
      puts "we don't have page!!!"
      return
    end
    new_article = WorkingArticle.where(page_id: page.id, order: story_number).first
    unless new_article
      puts "we don't the article with story number!!!"
      return
    end
    puts "new_article.id:#{new_article.id}"
    if new_article && new_article.id != current_article_id
      puts "change to different article"
      self.working_article_id = new_article.id
      self.used_in_layout = false
      self.save
      place_image
      # clear image from current_article, if it exits
    end
    if working_article
      working_article.generate_pdf
      working_article.update_page_pdf
    end
  end

  def self.current_images
    Image.where(issue_id: Issue.last.id).all
  end

  def self.place_all_images
    Image.current_images.each do |curremt_image|
      curremt_image.place_image unless curremt_image.used_in_layout
    end
  end

  def place_image
    if page_number && story_number
      page = Page.where(issue_id: issue_id, page_number: page_number).first
      return unless page
      working_article = WorkingArticle.where(page_id: page.id, order: story_number).first
      return unless working_article
      self.working_article_id = working_article.id
      working_article.generate_pdf
      working_article.update_page_pdf
      self.used_in_layout = true
      self.save
    end
  end

  def self.clear_all_images
    Image.current_images.each do |curremt_image|
      curremt_image.clear_image
    end
  end

  def clear_image
    if working_article && used_in_layout
      working_article.generate_pdf
      working_article.update_page_pdf
      self.used_in_layout = false
      self.save
    end
  end


  # return array of image_basename.split("_")
  # we want to see if page_number and story_number are specified in the file name.
  def parse_file_name
    return [] unless image
    image_basename  = File.basename(image.url)
    if image_basename =~ /^\d/
      image_basename.split("_")
    else
      []
    end
  end

  private

    def set_default
      self.column                 = 2
      self.row                    = 2
      self.extra_height_in_lines  = 0
      self.position               = 3
      self.landscape              = true

      if image
        parsed_name_array = parse_file_name
        if parsed_name_array.length >= 2
          self.page_number      = parsed_name_array[0].to_i
          self.story_number     = parsed_name_array[1].to_i
          self.column           = parsed_name_array[2] if  parsed_name_array.length >= 3
          self.row              = parsed_name_array[3] if  parsed_name_array.length >= 4
        end
      end
    end
end
