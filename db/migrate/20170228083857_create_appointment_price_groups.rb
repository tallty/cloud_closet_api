class CreateAppointmentPriceGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :appointment_price_groups do |t|
      t.references :price_system, foreign_key: true
      t.references :appointment, foreign_key: true
      t.integer :count
      t.integer :store_month
      t.float :unit_price
      t.float :price
      t.boolean :is_chest
      t.string :title

      t.timestamps
    end
  end
end
