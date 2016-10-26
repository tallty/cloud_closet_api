FactoryGirl.define do
  factory :user_info do
    nickname "userinfo nickname"
    mail "userinfo mail"
    association :avatar, factory: :image, photo_type: "avatar"
    balance "%.2f"%100000.00
  end
end
