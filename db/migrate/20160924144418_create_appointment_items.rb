class CreateAppointmentItems < ActiveRecord::Migration[5.0]
  def change
    create_table :appointment_items do |t|
      t.references :garment, foreign_key: true
      t.references :appointment, foreign_key: true
      t.integer :store_month
      t.float :price
      t.integer :status

      t.timestamps
    end
  end
end
