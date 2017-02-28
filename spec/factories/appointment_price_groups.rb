FactoryGirl.define do
  factory :appointment_price_group do
    price_system nil
    count 1
    store_month 1
    unit_price 1.5
    price 1.5
    is_chest false
  end
end
