FactoryGirl.define do
  factory :garment do
    title "garment title"
    put_in_time "2016-09-23 14:39:08"
    expire_time "2017-09-24 14:39:08"
    association :cover_image, factory: :image, photo_type: "cover"
  end
end
