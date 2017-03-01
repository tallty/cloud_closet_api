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
  factory :price_system do
  	sequence(:title) {|n| ['挂柜', '礼服柜', '礼服单柜'][n%3]}
    price 32
    association :price_icon_image, factory: :image, photo_type: "icon"
  end

  factory :stocking_chest , class: :price_system do
  	title '叠放柜'
    price 180
    description '*叠放柜可存放针织类，卫衣棉服等可折叠衣物60件, 也可提供真空袋出售；'
    is_chest true
    unit_name '月'
    association :price_icon_image, factory: :image, photo_type: "icon"
    # after(:create) do |modem_registry| modem_registry.gps_positions << create(:gps_position) end
  end
end

