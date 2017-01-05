class CreateChests < ActiveRecord::Migration[5.0]
  def change
    create_table :chests do |t|
      t.references :user, foreign_key: true
      t.references :appointment, foreign_key: true
      t.integer :classify
      t.integer :surplus
      t.string :description

      t.timestamps
    end
  end
end
