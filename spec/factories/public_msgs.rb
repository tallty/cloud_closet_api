FactoryGirl.define do
  factory :public_msg do
    title "公频通知 标题"
    abstract "公频通知 概述"
    content "公频通知 内容"
    association :public_msg_image, factory: :image, photo_type: "public_msg"
  end
end
