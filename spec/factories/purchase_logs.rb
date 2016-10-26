FactoryGirl.define do
  factory :purchase_log do
    type ""
    operation "MyString"
    change 1.5
    payment_method "MyString"
  end
end
