class ChangeAppointmentGroupColumns < ActiveRecord::Migration[5.0]
  def change
  	add_reference :appointment_item_groups, :price_system, foreign_key: true
  end
end
