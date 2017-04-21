FactoryGirl.define do
  factory :delivery_order do
    address "我是 地址"
    name "我是 联系人"
    phone "我是 联系人电话"
    delivery_time "2017-04-14"
    delivery_method "我是 配送方式"
    remark "我是 备注 备注 备注 ..."
    delivery_cost 100
    service_cost 200
  end
end
