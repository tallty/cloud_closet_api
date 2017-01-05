# == Schema Information
#
# Table name: appointment_items
#
#  id                        :integer          not null, primary key
#  garment_id                :integer
#  appointment_id            :integer
#  store_month               :integer
#  price                     :float
#  status                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  appointment_item_group_id :integer
#  chest_id                  :integer
#
# Indexes
#
#  index_appointment_items_on_appointment_id             (appointment_id)
#  index_appointment_items_on_appointment_item_group_id  (appointment_item_group_id)
#  index_appointment_items_on_chest_id                   (chest_id)
#  index_appointment_items_on_garment_id                 (garment_id)
#

FactoryGirl.define do
  factory :appointment_item do
  	sequence(:garment_id) { |n| "#{n}" }
  	sequence(:appointment_id) { |n| "#{n}" }
  	sequence(:chest_id) { |n| "#{n}" }
    store_month 1
    price 1.5
    status "unstore"
  end
end
