class CreateExhibitionUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :exhibition_units do |t|
      t.string :title
      t.integer :store_method
      t.integer :max_count
      t.boolean :need_join
      t.references :price_system, foreign_key: true

      t.timestamps
    end
  end
end
