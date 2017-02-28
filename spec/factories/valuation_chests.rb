FactoryGirl.define do
  factory :valuation_chest do
    price_system nil
    aasm_state "MyString"
    user nil
  end
end
