# == Schema Information
#
# Table name: appointment_item_groups
#
#  id              :integer          not null, primary key
#  count           :integer
#  appointment_id  :integer
#  store_month     :integer
#  price           :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  type_name       :string
#  season          :string
#  price_system_id :integer
#  chest_id        :integer
#
# Indexes
#
#  index_appointment_item_groups_on_appointment_id   (appointment_id)
#  index_appointment_item_groups_on_chest_id         (chest_id)
#  index_appointment_item_groups_on_price_system_id  (price_system_id)
#

FactoryGirl.define do
  factory :appointment_item_group do
    count 5
    store_month 3
    price 1.5
    type_name "上衣"
    season "秋"
  end
end
