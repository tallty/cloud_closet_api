# == Schema Information
#
# Table name: sms_tokens
#
#  id         :integer          not null, primary key
#  phone      :string
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  auth_key   :string
#
# Indexes
#
#  index_sms_tokens_on_phone  (phone)
#

FactoryGirl.define do
  factory :sms_token do
    phone "13813813811"
    token "1111"
  end
end
