# == Schema Information
#
# Table name: reporter_groups
#
#  id         :integer          not null, primary key
#  section    :string
#  leader     :string
#  page_range :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ReporterGroup < ApplicationRecord
  has_many :reporters
end
