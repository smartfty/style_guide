module ArticleSwapable
  extend ActiveSupport::Concern

  def swapable_attributes
    atts = attributes
    atts.delete('id')
    atts.delete('create_at')
    atts.delete('updated_at')
    atts.delete('column')
    atts.delete('row')
    atts.delete('order')
    atts.delete('on_left_edge')
    atts.delete('on_right_edge')
    atts.delete('is_front_page')
    atts.delete('top_story')
    atts.delete('top_position')
    atts.delete('extended_line_count')
    atts.delete('pushed_line_count')
    atts.delete('on_left_edge')
    atts.delete('on_right_edge')
    atts.delete('article_id')
    atts.delete('page_id')
    atts.delete('path')
    atts.delete('page_heading_margin_in_lines')
    atts.delete('announcement_text')
    atts.delete('announcement_column')
    atts.delete('announcement_color')    
    atts
  end

  def change_story_with(new_story)
    h = new_story[:heading]
    self.subject_head      = h['subject_head'] = subject_head
    self.title             = h['title']
    self.subtitle          = h['subtitle']
    self.quote             = h['quote']
    self.reporter          = h['reporter']
    self.email             = h['email']
    self.body              = new_story[:body]
    self.save
  end

  # swap with first sibling
  def swap
    return unless siblings.length == 1
    target = siblings.first
    target_attrubutes      = target.swapable_attributes
    target_images          = target.images
    target_graphics        = target.graphics
    target.swap_with(self)
    swap_with(target)
    target_images.each do |image|
      image.working_article_id = id
    end
    target_graphics.each do |graphic|
      graphic.working_article_id = id
    end
    generate_pdf_with_time_stamp
    update_page_pdf
  end

  def swap_with_article_at_order(order)
    target = page.working_articles[order - 1]
    return unless target
    target_attrubutes      = target.swapable_attributes
    target_images          = target.images
    target_graphics        = target.graphics
    target.swap_with(self)
    swap_with(temp)
    target_images.each do |image|
      image.working_article_id = id
    end
    target_graphics.each do |graphic|
      graphic.working_article_id = id
    end
    generate_pdf_with_time_stamp
    update_page_pdf
  end

  def swap_with(changing_article)
    changing_attributes         = changing_article.attrubutes
    changing_article_images     = changing_article.images
    changing_article_graphicss  = changing_article.graphics
    changing_attributes.delete('id')
    changing_attributes.delete('created_at')
    changing_attributes.delete('updated_at')
    update(changing_attributes)
    changing_article_images.each do |image|
      image.working_article_id = id
      image.save
    end
    changing_article_graphics.each do |graphic|
      graphic.working_article_id = id
      graphic.save
    end
    generate_pdf_with_time_stamp
  end

end