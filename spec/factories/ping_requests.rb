FactoryGirl.define do
  factory :ping_request do
    object_type "MyString"
    ping_id "MyString"
    complete false
    amount 1
    subject "MyString"
    body "MyString"
    client_ip "MyString"
    extra "MyString"
  end
end
