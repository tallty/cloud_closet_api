FactoryGirl.define do
  factory :invoice do
    title 'aaa'
    amount 200.00
    invoice_type "我是普通发票"
    cel_name "我是联系人姓名"
    cel_phone "我是联系人电话"
    postcode "我是邮政编码"
    address "我是地址"
    date "2017-03-20"
  end
end
