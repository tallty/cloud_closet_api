# == Schema Information
#
# Table name: exhibition_units
#
#  id              :integer          not null, primary key
#  title           :string
#  store_method    :string
#  max_count       :integer
#  need_join       :boolean
#  price_system_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_exhibition_units_on_price_system_id  (price_system_id)
#

FactoryGirl.define do
  # factory :exhibition_unit do
  #   title ""
  #   store_method 1
  #   max_count 1
  #   need_join false
  #   price_system nil
  # end

  factory :stacking_unit, class: :exhibition_unit do
    title "叠放柜"
    store_method "stacking"
    max_count 60
    need_join false
    association :exhibition_icon_image, factory: :image, photo_type: "exhibition_icon"
  end

  factory :hanging_unit, class: :exhibition_unit do
    title "挂柜"
    store_method "hanging"
    max_count 20
    need_join false
    association :exhibition_icon_image, factory: :image, photo_type: "exhibition_icon"
  end

  factory :group_stacking_unit, class: :exhibition_unit do
    title "组合柜-叠放柜"
    store_method "stacking"
    max_count 60
    need_join false
    association :exhibition_icon_image, factory: :image, photo_type: "exhibition_icon"
  end

  factory :group_hanging_unit, class: :exhibition_unit do
    title "组合柜-挂柜"
    store_method "hanging"
    max_count 20
    need_join false
    association :exhibition_icon_image, factory: :image, photo_type: "exhibition_icon"
  end

  factory :full_dress_unit, class: :exhibition_unit do
    title "礼服柜"
    store_method 3
    max_count 12
    need_join false
    association :exhibition_icon_image, factory: :image, photo_type: "exhibition_icon"
  end

  factory :alone_full_dress_unit, class: :exhibition_unit do
    title "单件礼服"
    store_method 3
    max_count 1
    need_join true
    association :exhibition_icon_image, factory: :image, photo_type: "exhibition_icon"
  end
end
