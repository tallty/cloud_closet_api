# == Schema Information
#
# Table name: ping_requests
#
#  id          :integer          not null, primary key
#  object_type :string
#  ping_id     :string
#  complete    :boolean
#  amount      :integer
#  subject     :string
#  body        :string
#  client_ip   :string
#  extra       :string
#  order_no    :string
#  channel     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  openid      :string
#  metadata    :string
#

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
