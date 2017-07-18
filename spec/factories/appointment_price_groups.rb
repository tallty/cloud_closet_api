# == Schema Information
#
# Table name: appointment_price_groups
#
#  id               :integer          not null, primary key
#  price_system_id  :integer
#  appointment_id   :integer
#  count            :integer
#  store_month      :integer
#  unit_price       :float
#  price            :float
#  is_chest         :boolean
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  service_order_id :integer
#
# Indexes
#
#  index_appointment_price_groups_on_appointment_id    (appointment_id)
#  index_appointment_price_groups_on_price_system_id   (price_system_id)
#  index_appointment_price_groups_on_service_order_id  (service_order_id)
#

FactoryGirl.define do
  factory :appointment_price_group do
    count 3
    store_month 4
  end
end
