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

class AppointmentItemGroup < ApplicationRecord
  belongs_to :appointment
  has_many :items, class_name: "AppointmentItem", dependent: :destroy
  has_many :garments, through: :items

  def create_item
    count.times do
      item = self.items.build(
        store_month: self.store_month,
        appointment: appointment
        )
      item.save
    end
  end
end
