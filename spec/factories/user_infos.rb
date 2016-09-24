FactoryGirl.define do
  factory :user_info do
    nickname "userinfo nickname"
    mail "userinfo mail"
    association :avatar, factory: :image, photo_type: "avatar"
  end
end
