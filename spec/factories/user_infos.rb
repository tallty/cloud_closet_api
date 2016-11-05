# == Schema Information
#
# Table name: user_infos
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  nickname           :string
#  mail               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  default_address_id :integer
#  balance            :float            default(0.0)
#
# Indexes
#
#  index_user_infos_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :user_info do
    nickname "userinfo nickname"
    mail "userinfo mail"
    association :avatar, factory: :image, photo_type: "avatar"
    balance 100000.00
  end
end
