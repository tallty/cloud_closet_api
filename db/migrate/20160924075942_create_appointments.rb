class CreateAppointments < ActiveRecord::Migration[5.0]
  def change
    create_table :appointments do |t|
      t.string :address
      t.string :name
      t.string :phone
      t.integer :number
      t.date :date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
