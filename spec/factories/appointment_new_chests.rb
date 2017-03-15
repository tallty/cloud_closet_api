# == Schema Information
#
# Table name: appointment_new_chests
#
#  id                         :integer          not null, primary key
#  appointment_price_group_id :integer
#  appointment_id             :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  exhibition_unit_id         :integer
#
# Indexes
#
#  index_appointment_new_chests_on_appointment_id              (appointment_id)
#  index_appointment_new_chests_on_appointment_price_group_id  (appointment_price_group_id)
#  index_appointment_new_chests_on_exhibition_unit_id          (exhibition_unit_id)
#

FactoryGirl.define do
  factory :appointment_new_chest do
    chest nil
    appointment_price_group nil
  end
end
