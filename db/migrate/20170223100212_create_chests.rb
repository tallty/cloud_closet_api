class CreateChests < ActiveRecord::Migration[5.0]
  def change
    create_table :chests do |t|
      t.string :title
      t.string :chest_type
      t.integer :max_count
      t.references :user, foreign_key: true
			t.references :price_system, foreign_key: true

      t.timestamps
    end
  end
end
