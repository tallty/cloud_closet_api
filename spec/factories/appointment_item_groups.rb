# == Schema Information
#
# Table name: appointment_item_groups
#
#  id             :integer          not null, primary key
#  count          :integer
#  appointment_id :integer
#  store_month    :integer
#  price          :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  type_name      :string
#
# Indexes
#
#  index_appointment_item_groups_on_appointment_id  (appointment_id)
#

FactoryGirl.define do
  factory :appointment_item_group do
    count 5
    store_month 3
    price 1.5
    type_name "上衣"
  end
end
