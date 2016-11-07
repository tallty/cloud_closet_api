# == Schema Information
#
# Table name: purchase_logs
#
#  id             :integer          not null, primary key
#  operation_type :string
#  operation      :string
#  change         :float
#  payment_method :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_info_id   :integer
#  detail         :string
#  balance        :float
#
# Indexes
#
#  index_purchase_logs_on_user_info_id  (user_info_id)
#

FactoryGirl.define do
  factory :purchase_log do
    operation_type "消费/在线支付"
    operation "购买衣橱"
    change -2000.00
    payment_method "微信支付"
    detail "裤子×2 衣服×3"
    sequence(:created_at,0) {|n| Time.now - n.day}
  end
end
