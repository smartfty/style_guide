module PageSplitable
  extend ActiveSupport::Concern

  def split_article_in_page(article, rects_array)
    first_rect  = rects_array[0]
    second_rect = rects_array[1]
    # nake copy of article for split second article
    second_article_atts = article.attributes
    second_article_atts.delete('id')
    second_article_atts.delete('article_id')
    second_article_atts.delete('created_at')
    second_article_atts.delete('updated_at')
    second_article_atts.delete('slug')
    # update size of first split article
    article.grid_x = first_rect[0]
    article.grid_y = first_rect[1]
    article.column = first_rect[2]
    article.row    = first_rect[3]
    article.save
    index          = article.order - 1
    section        = Section.find(template_id)
    if !©72template_id.nil?
      self.layout = section.layout
    end
    story_frames = eval(self.layout)
    story_frames.delete_at(index)
    story_frames.insert(index, rects_array[0])
    story_frames.insert(index + 1, rects_array[1])
    self.layout = story_frames.to_s
    self.save
    # create second article
    second_article_atts['grid_x'] = second_rect[0]
    second_article_atts['grid_y'] = second_rect[1]
    second_article_atts['column'] = second_rect[2]
    second_article_atts['row']    = second_rect[3]
    second_article_atts['page_id']= self.id
    # assing temp order, and update the order accoring to the box position
    second_article_atts['order']  = working_articles.length + 1
    second_article_atts           = Hash[second_article_atts.map{ |k, v| [k.to_sym, v] }]
    binding.pry
    new_article = WorkingArticle.create!(second_article_atts)
    update_working_article_order_by_position
    # new_article.generate_pdf
    # article.generate_pdf_with_time_stamp
    update_page_after_split
  end

  def make_profile
    profile = "#{column}x#{row}_"
    profile += "H_" if is_front_page?
    profile += "#{ad_type}_" if ad_type
    profile += story_count.to_s
    profile
  end
  # update order by box position
  def update_working_article_order_by_position
    sorted_box = working_articles.sort_by{|article| [article.grid_y, article.grid_x]}
    sorted_box.each_with_index do |article, i|
      article.order = i + 1
      article.save
    end
  end

  def update_config_yml
    source        = config_path
    config_hash   = YAML::load_file(source)
    config_hash['story_frames'] = eval(layout)
    File.open(source, 'w'){|f| f.write(config_hash.to_yaml)}
  end

  def regenerate_all_atricles
    working_articles.each do |article|
      article.generate_pdf
    end
  end

  def update_page_after_split
    self.story_count += 1
    self.profile = make_profile
    self.template_id = nil
    self.save
    update_config_yml
    regenerate_all_atricles
    generate_pdf_with_time_stamp
  end
end
