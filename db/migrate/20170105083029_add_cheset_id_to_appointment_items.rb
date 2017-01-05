class AddChesetIdToAppointmentItems < ActiveRecord::Migration[5.0]
  def change
  	change_table :appointment_items do |t|
  	  t.references :chest, foreign_key: true
  	end
  end
end
