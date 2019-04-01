# == Schema Information
#
# Table name: exert_writers
#
#  id               :bigint(8)        not null, primary key
#  name             :string
#  work             :string
#  position         :string
#  email            :string
#  category_code    :integer
#  expert_image     :string
#  expert_jpg_image :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe ExertWriter, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
