# == Schema Information
#
# Table name: price_systems
#
#  id            :integer          not null, primary key
#  price         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  item_type     :integer
#  max_count_per :integer
#  title         :string
#

FactoryGirl.define do
  factory :price_system do
  	sequence(:name,0) {|n| "上衣#{n}"}
  	sequence(:season,0) {|n| "春#{n}"}
    price 32
    association :icon_image, factory: :image, photo_type: "icon"
  end
end
