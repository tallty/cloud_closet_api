# == Schema Information
#
# Table name: price_systems
#
#  id          :integer          not null, primary key
#  price       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  title       :string
#  is_chest    :boolean
#  description :text
#  unit_name   :string
#

FactoryGirl.define do
  # factory :price_system do
  # 	sequence(:title) {|n| ['挂柜', '礼服柜', '礼服单柜'][n%3]}
  #   price 32
  #   association :price_icon_image, factory: :image, photo_type: "price_icon"
  # end

  factory :stocking_chest , class: :price_system do
    # before(:create) do |price_system|  end
  	title '叠放柜'
    price 180
    description '*叠放柜可存放针织类，卫衣棉服等可折叠衣物60件, 也可提供真空袋出售；'
    is_chest true
    unit_name '月'
    association :price_icon_image, factory: :image, photo_type: "price_icon"
    after(:create) do |price_system| price_system.exhibition_units << create(:hanging_unit) end
  end

  factory :group_chest1 , class: :price_system do
    title '组合柜'
    price 400
    description '*组合柜可存放60件折叠和20件挂放'
    is_chest true
    unit_name '月'
    association :price_icon_image, factory: :image, photo_type: "price_icon"
    after(:create) do |price_system| price_system.exhibition_units << create(:group_hanging_unit) end
    after(:create) do |price_system| price_system.exhibition_units << create(:group_stacking_unit) end
  end

  factory :alone_full_dress_chest , class: :price_system do
    title '单件礼服'
    price 60
    description '我是单件礼服 ,每月60'
    is_chest true
    unit_name '月'
    association :price_icon_image, factory: :image, photo_type: "price_icon"
    after(:create) do |price_system| price_system.exhibition_units << create(:alone_full_dress_unit) end
  end

  factory :vacuum_bag_medium , class: :price_system do
    title '真空袋-中'
    price 10
    description '我是真空袋'
    is_chest false
    unit_name '个'
    association :price_icon_image, factory: :image, photo_type: "price_icon"
  end
end

