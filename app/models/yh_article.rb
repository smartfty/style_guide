# == Schema Information
#
# Table name: yh_articles
#
#  id              :bigint(8)        not null, primary key
#  action          :string
#  service_type    :string
#  content_id      :string
#  date            :date
#  time            :string
#  urgency         :string
#  category        :string
#  class_code      :string
#  attriubute_code :string
#  source          :string
#  credit          :string
#  region          :string
#  title           :string
#  body            :text
#  writer          :string
#  char_count      :integer
#  taken_by        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class YhArticle < ApplicationRecord

  def taken_by(user)
    self.taken_by = user.name
    self.save
  end
end
