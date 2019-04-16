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

 end