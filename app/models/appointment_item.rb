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
#
# Indexes
#
#  index_appointment_items_on_appointment_id             (appointment_id)
#  index_appointment_items_on_appointment_item_group_id  (appointment_item_group_id)
#  index_appointment_items_on_garment_id                 (garment_id)
#

class AppointmentItem < ApplicationRecord
  belongs_to :garment
  belongs_to :appointment
  belongs_to :appointment_item_group

  after_create :create_relate_garment

  private
    def create_relate_garment
      self.create_garment(user: appointment.try(:user))
    end
end
