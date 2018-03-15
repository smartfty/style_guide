# == Schema Information
#
# Table name: reporters
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  title             :string
#  reporter_group_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Reporter < ApplicationRecord
  belongs_to :reporter_group
end
