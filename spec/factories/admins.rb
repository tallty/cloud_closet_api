FactoryGirl.define do
  factory :admin do
    email "admin@example.com"
    password "123456"
    authentication_token "qwertyuiop1"
  end
end
