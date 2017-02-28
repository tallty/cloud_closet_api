class CreateAppointmentNewChests < ActiveRecord::Migration[5.0]
  def change
    create_table :appointment_new_chests do |t|
      t.references :exhibition_chest, foreign_key: true
      t.references :appointment_price_group, foreign_key: true
      t.references :appointment, foreign_key: true

      t.timestamps
    end
  end
end
