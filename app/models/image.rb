# == Schema Information
#
# Table name: images
#
#  id                    :integer          not null, primary key
#  column                :integer
#  row                   :integer
#  extra_height_in_lines :integer
#  image                 :string
#  caption_title         :string
#  caption               :string
#  source                :string
#  position              :integer
#  page_number           :integer
#  story_number          :integer
#  landscape             :boolean
#  used_in_layout        :boolean
#  working_article_id    :integer
#  issue_id              :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  extra_line            :integer
#  x_grid                :integer
#  y_in_lines            :integer
#  height_in_lines       :integer
#  draw_frame            :boolean
#  zoom_level            :integer
#  zoom_direction        :integer
#  move_level            :integer
#  auto_size             :integer
#  fit_type              :string
#  image_kind            :string
#  not_related           :boolean
#  reporter_image_path   :string
#

class Image < ApplicationRecord
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  belongs_to :issue, optional: true
  belongs_to :working_article, optional: true
  mount_uploader :image, ImageUploader
  before_create  :set_default
  before_save    :save_default_value

  def info
    h = {}
    h[:position]              = position
    h[:extra_height_in_lines] = extra_height_in_lines || 0 #if extra_height_in_lines && extra_height_in_lines != 0
    h[:column]                = column
    h[:row]                   = row
    h[:x_grid]                = x_grid if x_grid
    h
  end

  def image_path
    if image.url
     "#{Rails.root}/public" + image.url
    elsif reporter_image_path
      "#{Rails.root}/public" + reporter_image_path
    else
     "#{Rails.root}/public" + "/place_holder_image.jpg"
    end
  end

  def empty_image_url
    "/place_holder_image.jpg"
  end

  def size_string
    width_in_mm   = ((working_article.grid_width*column - working_article.gutter)*0.352778).round(2)
    # 4 is value adjustef to align image with body text
    extra_height_in_lines = 0 unless extra_height_in_lines
    height_in_mm  = ((working_article.grid_height*row + working_article.body_line_height*extra_height_in_lines - 4)*0.352778).round(3)
    "#{width_in_mm}mm x #{height_in_mm}mm"
  end

  def publication
    issue.publication
  end

  def page_number
    working_article.page_number
  end

  def article_order
    working_article.order
  end

  # currnt image count
  # this becomes part of next images's file name
  # page_number_article_number_image_count.extension
  def image_count
    working_article.images.length
  end

  def correct_image_path
    if  working_article.images.length == 1
      image.path 
    end
  end

  #'최적' '가로', '세로', '욱여넣기'
  # MAGE_FIT_TYPE_ORIGINAL        = 0
  # IMAGE_FIT_TYPE_VERTICAL       = 1
  # IMAGE_FIT_TYPE_HORIZONTAL     = 2
  # IMAGE_FIT_TYPE_KEEP_RATIO     = 3
  # IMAGE_FIT_TYPE_IGNORE_RATIO   = 4
  # IMAGE_FIT_TYPE_REPEAT_MUTIPLE = 5
  # IMAGE_CHANGE_BOX_SIZE         = 6 #change box size to fit image source as is at origin

  def image_layout_hash
    h = {}
    h[:image_path]        = image_path
    h[:column]            = column
    h[:row]               = row
    h[:position]          = position.to_i
    h[:extra_height_in_lines]   = extra_height_in_lines || 0
    h[:is_float]          = true
    h[:caption_title]     = RubyPants.new(caption_title).to_html if caption_title
    h[:caption]           = RubyPants.new(caption).to_html if caption
    h[:source]            = source if source
    case fit_type
    when '최적'
      h[:fit_type] = 3
      h[:zoom_level]      = zoom_level if zoom_level
      #TODO change field zoom_direction to zoom_anchor
      h[:zoom_anchor]     = zoom_direction if zoom_direction
    when '세로'
      h[:fit_type] = 1 
    when '가로'
      h[:fit_type] = 2 
    when '욱여넣기'
      h[:fit_type] = 4
    else
      h[:fit_type] = 3 
    end
    h[:x_grid]            = x_grid - 1 if x_grid # user_input - 1
    h[:draw_frame]        = draw_frame || true
    h[:image_kind]        = image_kind if image_kind 
    h
  end

  # set current_article_id, if page_number and story_number is given
  # why do we have to call this?
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
    # if working_article
    #   working_article.generate_pdf
    #   working_article.update_page_pdf
    # end
  end

  def self.current_images
    Image.where(issue_id: Issue.last.id).all
  end

  def self.place_all_images
    Image.current_images.each do |current_image|
      current_image.place_image unless current_image.used_in_layout
    end
  end

  def place_image
    if page_number && story_number
      page = Page.where(issue_id: issue_id, page_number: page_number).first
      return unless page
      working_article = WorkingArticle.where(page_id: page.id, order: story_number).first
      return unless working_article
      self.working_article_id = working_article.id
      working_article.generate_pdf_with_time_stamp
      working_article.update_page_pdf
      self.used_in_layout = true
      self.save
    end
  end

  def self.clear_all_images
    Image.current_images.each do |current_image|
      current_image.clear_image
    end
  end

  def clear_image
    if working_article && used_in_layout
      working_article.generate_pdf_with_time_stamp
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

  def current_image_size
    "#{column}x#{row}"
  end

  # return false if new image size is same as old
  def change_size(size)
    return false if size == current_image_size
    if size == 'auto'
      new_column, new_row, new_extra_lines = working_article.calculate_fitting_image_size(column, row, extra_height_in_lines)
      return false if column == new_column && row == new_row && extra_height_in_lines == new_extra_lines
      self.column                 = new_column
      self.row                    = new_row
      self.extra_height_in_lines  = new_extra_lines
      self.save
      true
    elsif size.include?("x")
      size_array  = size.split("x")
      self.column = size_array[0].to_i
      self.row    = size_array[1].to_i
      self.save
      true
    else
      puts "wrong size format!!!"
      return false
    end
  end
  
  def save_default_value
    self.extra_height_in_lines  = 0 unless extra_height_in_lines
    self.row                    = 2 unless row
  end

  private

    def set_default
      self.column                 = 2 unless column
      self.row                    = 2 unless row
      self.extra_height_in_lines  = 0
      self.position               = 3
      self.fit_type               = 3 #'최적' '상하', '좌우', '욱여넣기'

      if working_article_id
        wa = WorkingArticle.find(working_article_id)
        self.issue_id         = wa.page.issue.id
        self.page_number      = wa.page.page_number
        self.story_number     = wa.order
        self.used_in_layout   = true

      elsif image
        parsed_name_array = parse_file_name
        if parsed_name_array.length >= 2
          self.page_number      = parsed_name_array[0].to_i
          self.story_number     = parsed_name_array[1].to_i
          self.column           = parsed_name_array[3] if  parsed_name_array.length >= 4
          self.row              = parsed_name_array[4] if  parsed_name_array.length >= 5
        end
      end
    end
end
