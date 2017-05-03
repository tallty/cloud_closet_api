# == Schema Information
#
# Table name: recharge_rules
#
#  id         :integer          not null, primary key
#  amount     :float(24)
#  credits    :float(24)        default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RechargeRule < ApplicationRecord
end
