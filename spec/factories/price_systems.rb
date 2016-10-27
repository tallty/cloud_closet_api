FactoryGirl.define do
  factory :price_system do
    name "上衣"
    season "春夏"
    price 32
    association :icon_image, factory: :image, photo_type: "icon"
  end
end
