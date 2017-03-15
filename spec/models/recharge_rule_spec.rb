# == Schema Information
#
# Table name: recharge_rules
#
#  id         :integer          not null, primary key
#  amount     :float
#  credits    :float            default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe RechargeRule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
