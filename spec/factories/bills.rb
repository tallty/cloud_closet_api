FactoryGirl.define do
  factory :bill do
    amount "9.99"
    bill_type 1
    seq "MyString"
    sign "MyString"
    user nil
  end
end
