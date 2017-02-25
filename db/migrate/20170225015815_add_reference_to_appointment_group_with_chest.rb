class AddReferenceToAppointmentGroupWithChest < ActiveRecord::Migration[5.0]
  def change
  	add_reference :appointment_item_groups, :chest, foreign: true
  end
end
