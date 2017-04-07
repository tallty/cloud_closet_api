# == Schema Information
#
# Table name: vip_levels
#
#  id            :integer          not null, primary key
#  name          :string
#  exp           :integer
#  birthday_gift :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rank          :integer
#

require 'rails_helper'

RSpec.describe VipLevel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
