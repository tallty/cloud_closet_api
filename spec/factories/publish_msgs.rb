FactoryGirl.define do
  factory :publish_msg do
    title "公频通知 标题"
    abstract "公频通知 概述"
    content "公频通知 内容"
    association :publish_msg_image, factory: :image, photo_type: "publish_msg"
  end
end
