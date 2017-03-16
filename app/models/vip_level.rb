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

class VipLevel < ApplicationRecord
	default_scope { order(:rank) }
	validates	:rank, uniqueness: true
end
