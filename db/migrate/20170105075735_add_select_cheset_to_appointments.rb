class AddSelectChesetToAppointments < ActiveRecord::Migration[5.0]
  def change
  	change_table :appointments do |t|
  	  t.string :select_chest
  	end
  end
end
