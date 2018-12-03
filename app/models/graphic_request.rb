# == Schema Information
#
# Table name: graphic_requests
#
#  id               :bigint(8)        not null, primary key
#  date             :date
#  title            :string
#  requester        :string
#  person_in_charge :string
#  status           :string
#  description      :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class GraphicRequest < ApplicationRecord
end
