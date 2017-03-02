class AddReferenceToAppointmentNewChestWithExhibitionUnit < ActiveRecord::Migration[5.0]
  def change
  	add_reference :appointment_new_chests, :exhibition_unit, foreigin_key: true
  end
end
