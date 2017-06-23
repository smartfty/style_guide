# == Schema Information
#
# Table name: images
#
#  id                 :integer          not null, primary key
#  column             :integer
#  row                :integer
#  height_in_lines    :integer
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
  belongs_to :working_article

  def image_base_name
    File.basename(image_path)
  end

  def relative_path
    "/#{issue.relative_path}/images/#{image_base_name}"
  end

  def iamge_layout_hash
    h = {}
    h[:image_path]        = image_path
    h[:column]            = column
    h[:row]               = row
    h[:position]          = position
    h[:height_in_lines]   = height_in_lines
    h[:is_float]          = true
    h[:caption_title]     = caption_title
    h[:caption]           = caption
    h
  end

  def update_change
    puts __method__
    current_article_id = working_article_id
    page        = Page.where(issue_id: issue_id, page_number: page_number).first
    new_article = WorkingArticle.where(page_id: page.id, order: story_number).first
    puts "new_article.id:#{new_article.id}"
    if new_article && update_change.id != current_article_id
      puts "change to different article"
      self.working_article_id = new_article.id
      self.save
      new_article.generate_pdf
      WorkingArticle.find(current_article_id).generate_pdf
    end
  end

  def self.current_images
    last_issue = Issue.last
    Image.where(issue_id: last_issue).all
  end

  def self.place_all_images
    Image.current_images.each do |curremt_image|
      curremt_image.place_image
    end
  end

  def place_image
    if working_article && !used_in_layout
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
end
