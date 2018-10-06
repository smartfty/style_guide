# == Schema Information
#
# Table name: stories
#
#  id                 :bigint(8)        not null, primary key
#  user_id            :bigint(8)
#  working_article_id :bigint(8)
#  reporter           :string
#  group              :string
#  date               :date
#  title              :string
#  subtitle           :string
#  body               :string
#  quote              :string
#  status             :string
#  char_count         :integer
#  published          :boolean
#  path               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_stories_on_user_id             (user_id)
#  index_stories_on_working_article_id  (working_article_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (working_article_id => working_articles.id)
#

class Story < ApplicationRecord
  belongs_to :user
  belongs_to :working_article, optional: true
  before_create :init_atts

  def status_string
    selected = "X"
    selected = "O" if status == "published" if 
    s = "#{selected}| #{reporter}: #{title}"
    s
  end

  private

  def init_atts
    self.reporter = user.name
    self.status   = 'draft'
    self.date     = Date.today
    if working_article
      self.path = working_article.path
      self.published = true
    end
  end
end
