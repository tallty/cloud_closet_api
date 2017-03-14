# == Schema Information
#
# Table name: purchase_logs
#
#  id             :integer          not null, primary key
#  operation      :string
#  payment_method :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_info_id   :integer
#  detail         :text
#  balance        :float
#  amount         :float
#  is_increased   :boolean
#  credit         :integer
#  actual_amount  :float
#
# Indexes
#
#  index_purchase_logs_on_user_info_id  (user_info_id)
#

FactoryGirl.define do
  factory :purchase_log do
    operation "购买衣橱"
    payment_method "微信支付"
    detail "裤子,2;衣服,3;"
    is_increased false
    amount 111
    sequence(:created_at,0) {|n| Time.now - n.day}
  end
end
