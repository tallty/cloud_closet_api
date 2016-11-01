# == Schema Information
#
# Table name: price_systems
#
#  id         :integer          not null, primary key
#  name       :string
#  season     :string
#  price      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :price_system do
    name "上衣"
    season "春夏"
    price 32
    association :icon_image, factory: :image, photo_type: "icon"
  end
end
