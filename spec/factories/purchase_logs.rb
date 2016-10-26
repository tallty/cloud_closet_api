FactoryGirl.define do
  factory :purchase_log do
    operation_type "消费/在线支付"
    operation "购买衣橱"
    change -2000.00
    payment_method "微信支付"
    sequence(:created_at,0) {|n| Time.now - n.day}
  end
end
