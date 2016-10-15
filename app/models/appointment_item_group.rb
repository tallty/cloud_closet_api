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
#
# Indexes
#
#  index_appointment_item_groups_on_appointment_id  (appointment_id)
#

class AppointmentItemGroup < ApplicationRecord
  belongs_to :appointment
  has_many :items, class_name: "AppointmentItem", dependent: :destroy
  has_many :garments, through: :items
end
