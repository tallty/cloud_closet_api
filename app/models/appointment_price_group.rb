# == Schema Information
#
# Table name: appointment_price_groups
#
#  id              :integer          not null, primary key
#  price_system_id :integer
#  appointment_id  :integer
#  count           :integer
#  store_month     :integer
#  unit_price      :float
#  price           :float
#  is_chest        :boolean
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_appointment_price_groups_on_appointment_id   (appointment_id)
#  index_appointment_price_groups_on_price_system_id  (price_system_id)
#

class AppointmentPriceGroup < ApplicationRecord
  belongs_to :price_system
  belongs_to :appointment
  has_many :appointment_new_chests
end
