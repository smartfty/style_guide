# == Schema Information
#
# Table name: stories
#
#  id                 :bigint(8)        not null, primary key
#  user_id            :bigint(8)
#  working_article_id :bigint(8)
#  date               :date
#  reporter           :string
#  group              :string
#  title              :string
#  subtitle           :string
#  quote              :string
#  body               :string
#  char_count         :integer
#  status             :string
#  for_front_page     :boolean
#  summitted          :boolean
#  selected           :boolean
#  published          :boolean
#  summitted_at       :time
#  path               :string
#  order              :integer
#  image_name         :string
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
  before_save :count_chars

  def status_string
    selected = "X"
    selected = "O" if status == "selected" 
    selected
  end

  private
  
  def count_chars
    self.char_count = body.length
  end

  def init_atts
    self.reporter = user.name
    self.group    = user.group
    self.status   = 'draft'
    self.date     = Date.today unless date
    self.title    = "제목은 여기에 입력 합니다." unless title
    self.body     = "본문은 여기에 입력 합니다. "*5 unless body
    self.char_count = self.body.length
    if working_article
      self.path = working_article.path
    end
  end
end
