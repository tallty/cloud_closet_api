# == Schema Information
#
# Table name: vip_levels
#
#  id            :integer          not null, primary key
#  name          :string
#  xp            :integer
#  birthday_gift :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class VipLevel < ApplicationRecord
end
