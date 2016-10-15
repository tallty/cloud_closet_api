class AddAppointmentItemGroupToAppointmentItem < ActiveRecord::Migration[5.0]
  def change
    add_reference :appointment_items, :appointment_item_group, foreign_key: true
  end
end
