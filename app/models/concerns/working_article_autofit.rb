 
 # autofit siblings with image insertion
 # once siblings unoccuped total area is calculafet
 # and if the unoccuped total area us short
 # so that we need to insert picture, add picture place holder

 # expand and push sibling
 # expand and move sibling 
 
 # autofit and push sibling
 # autofit and move sibling 

 module WorkingArticleAutofit
  extend ActiveSupport::Concern

  def auto_size_image(options={})
    target_image = options[:image] if options[:image]
    unless target_image
      target_image = images.first
    end
    return unless target_image
    image_column = target_image.column
    if empty_lines_count
      size_to_extend = empty_lines_count/image_column
      puts "size_to_extend:#{size_to_extend}"
    elsif overflow_line_count
      size_to_reduce = overflow_line_count/image_column
      puts "size_to_reduce:#{size_to_reduce}"
    end
  end

  def auto_fit_graphic(options={})

  end

  def autofit_by_height(options={})
    if overflow?
      proposed_extend = overflow_line_count/column
      plus_line = overflow_line_count % column
      if options[:enough_space]
        proposed_extend += 1 if plus_line > 0
      end
      extend_line(proposed_extend) if expandable?(proposed_extend)
    elsif underflow?
      proposed_reduce = - empty_lines_count/column
      plus_line = empty_lines_count % column
      if options[:enough_space]
        proposed_reduce += 1 if plus_line > 0
      end
      extend_line(proposed_reduce)
    end
  end

  def autofit_with_sibllings(options={})
    autofit_by_height(options)
    sybs = siblings
    sybs.each do |syb|
      sub_opt = {}
      sub_opt[:enough_space] = true if options[:enough_space] == true
      sub_opt[generate_pdf:false]
      syb.autofit_with_sibllings(sub_opt)
    end
    page.generate_pdf_with_time_stamp
  end

  def autofit_by_image_size(options={})
    if overflow?
      if images.length > 0
        image = images.first
        proposed_image_reduce = overflow_lines/image.column
      end
    elsif underflow?
      if images.length > 0
        image = images.first
        proposed_image_extemd = empty_lines_count/image.column
      elsif empty_lines_count > 28 && (column > 3 || row > 3)
        # create 2x2
        create_image_place_holder(2,2)
      elsif empty_lines_count > 14 
        if column >= 2
        # create 2x1
          create_image_place_holder(2,1)
        else
          create_image_place_holder(1,2)
        end

      elsif empty_lines_count > 7
        create_image_place_holder(1,1)
      end
      generate_pdf_with_time_stamp    
      page.generate_pdf_with_time_stamp    
    end
  end

  def title_area_in_lines
    column*4
  end

  def subtitle_area_in_lines
    3
  end

  def images_area_in_lines
    area = 0
    area += images.map{|img| img.area_in_lines} if images.length > 0
    area
  end

  def graphics_area_in_lines
    area = 0
    area += graphics.map{|img| img.area_in_lines} if images.length > 0
    area
  end

  def quote_area_in_lines
    area = 0
  end

  def total_area_in_lines
    column*row*7
  end

  def available_line_space
    total_area = total_area_in_lines
    total_area += extended_line_count*column if extended_line_count
    total_area -= pushed_line_count*column if pushed_line_count
    occupied_area_in_lines = 0
    occupied_area_in_lines += title_area_in_lines if title
    occupied_area_in_lines += subtitle_area_in_lines if subtitle
    occupied_area_in_lines += images_area_in_lines
    occupied_area_in_lines += graphics_area_in_lines
    occupied_area_in_lines += quote_area_in_lines
    occupied_area_in_lines
    total_area - occupied_area_in_lines
  end

 end