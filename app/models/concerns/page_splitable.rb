module PageSplitable
  extend ActiveSupport::Concern

  def split_article_in_page(article, rects_array)
    first_rect = rects_array[0]
    second_rect = rects_array[1]
    # nake copy of article for split second article
    second_article_atts = article.attributes
    second_article_atts.delete('id')
    second_article_atts.delete('created_at')
    second_article_atts.delete('updateded_at')
    # update size of first split article
    article.x = first_rect[0]
    article.y = first_rect[1]
    article.column = first_rect[2]
    article.row = first_rect[3]
    article.save
    # update story_frames
    index = article.order - 1
    story_frames = eval(layout)
    story_frames.delete_at(index)
    story_frames.insert(index, rects_array[0])
    story_frames.insert(index + 1, rects_array[1])
    self.layout = story_frames.to_s
    self.save
    # create second article
    second_article_atts[:x] = second_rect[0]
    second_article_atts[:y] = second_rect[1]
    second_article_atts[:column] = second_rect[2]
    second_article_atts[:row] = second_rect[3]
    if article.is_a?(WorkingArticle)
      second_article_atts[:page_id] = self.id
      new_article = WorkingArticle.create(second_article_atts)
      new_article.generate_pdf
      article.generate_pdf_with_time_stamp
    else
      second_article_atts[:section_id] = self.id
      a = Article.create(second_article_atts)
      new_article.generate_pdf
      article.generate_pdf
    end
  end

end
