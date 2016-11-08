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
  	sequence(:name,0) {|n| "上衣#{n}"}
  	sequence(:season,0) {|n| "春#{n}"}
    price 32
    association :icon_image, factory: :image, photo_type: "icon"
  end
end
