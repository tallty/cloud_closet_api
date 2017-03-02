class ChangeReferenceBetweenAppointmentNewChestAndExhibitionChest < ActiveRecord::Migration[5.0]
  def change
  	remove_reference :appointment_new_chests, :exhibition_chest, foreign_key: true
  	add_reference :exhibition_chests, :appointment_new_chest, foreign_key: true
  end
end
