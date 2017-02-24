class CreateChestItems < ActiveRecord::Migration[5.0]
  def change
    create_table :chest_items do |t|
      t.references :price_system, foreign_key: true
      t.references :chest, foreign_key: true
      t.references :garment, foreign_key: true

      t.timestamps
    end
  end
end
