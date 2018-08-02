module SectionSplitable
  extend ActiveSupport::Concern
  
  def split_article_in_page(article, rects_array)
    first_rect = rects_array[0]
    second_rect = rects_array[1]
    # nake copy of article for split second article
    second_article_atts = article.attributes
    second_article_atts.delete('id')
    second_article_atts.delete('article_id')
    second_article_atts.delete('created_at')
    second_article_atts.delete('updated_at')
    # update size of first split article
    article.grid_x = first_rect[0]
    article.grid_y = first_rect[1]
    article.column = first_rect[2]
    article.row = first_rect[3]
    article.save
    # update story_frames
    index = article.order - 1
    if self.class == Section || layout
      # for Section
      story_frames = eval(layout)
    else
      # for Page
      section  = Section.find(template_id)
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
    second_article_atts['row'] = second_rect[3]
    if article.is_a?(WorkingArticle)
      second_article_atts['page_id'] = self.id
      binding.pry
      new_article = WorkingArticle.where(second_article_atts).first_or_create
      new_article.generate_pdf
      article.generate_pdf_with_time_stamp
      update_page_after_split
    else
      second_article_atts['section_id'] = self.id
      a = Article.create(second_article_atts)
      new_article.generate_pdf
      article.generate_pdf
      update_section_after_split
    end
  end

  def make_profile
    profile = "#{column}x#{row}_"
    profile += "H_" if is_front_page
    profile += "#{ad_type}_" if ad_type
    profile += story_count.to_s
    profile
  end

  def uodate_article_order
    articles.each_with_index do |article, i|
      article.order = i + 1
      article.save
    end
  end

  def uodate_working_article_order
    working_articles.each_with_index do |article, i|
      article.order = i + 1
      article.save
    end
  end

  def update_page_after_split
    self.story_count += 1
    self.profile = make_profile
    if self.is_a?(page)
      self.section_id = nil
      self.save
      uodate_working_article_order
      generate_pdf_with_time_stamp
    else
      self.save
      uodate_article_order
      generate_pdf
    end
  end
end
