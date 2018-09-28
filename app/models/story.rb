class Story < ApplicationRecord
  belongs_to :user
  belongs_to :working_article, optional: true
  before_create :init_atts

  def draft?
    status == 'draft'
  end

  private

  def init_atts
    self.status    = 'draft'
    if working_article
      self.published = true 
      self.path      = working_article.path + '/story.md'
      self.section   = working_article.section_name
    end
  end
end
