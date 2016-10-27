class CreatePriceSystems < ActiveRecord::Migration[5.0]
  def change
    create_table :price_systems do |t|
      t.string :name
      t.string :season
      t.integer :price

      t.timestamps
    end
  end
end
