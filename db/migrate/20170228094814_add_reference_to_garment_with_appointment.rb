class AddReferenceToGarmentWithAppointment < ActiveRecord::Migration[5.0]
  def change
  	add_reference :garments, :appointment, foreign: true
  	add_reference :garments, :exhibition_chest, foreign: true

  	# remove_reference :garments, :chest, foreign: true
  end
end
