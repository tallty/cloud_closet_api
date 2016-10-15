class CreateAppointmentItemGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :appointment_item_groups do |t|
      t.integer :count
      t.references :appointment, foreign_key: true
      t.integer :store_month
      t.float :price

      t.timestamps
    end
  end
end
