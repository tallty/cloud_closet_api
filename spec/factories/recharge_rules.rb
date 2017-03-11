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

FactoryGirl.define do
  factory :recharge_rule do
    amount_ary = [ 1000, 2000, 3000, 5000, 10000 ]
    credits_ary = [ 0, 0, 100, 300, 800 ]
    sequence(:amount, 0) { |n| amount_ary[n % amount_ary.count] }
    sequence(:credits, 0) { |n| credits_ary[n % credits_ary.count] }
  end
end
