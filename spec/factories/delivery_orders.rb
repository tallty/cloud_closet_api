FactoryGirl.define do
  factory :delivery_order do
    address "MyString"
    name "MyString"
    phone "MyString"
    delivery_time "2017-04-14"
    delivery_method "MyString"
    remark "MyString"
    delivery_cost 1
    service_cost 1
    user nil
  end
end
