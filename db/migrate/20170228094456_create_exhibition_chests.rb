class CreateExhibitionChests < ActiveRecord::Migration[5.0]
  def change
    create_table :exhibition_chests do |t|
      t.references :exhibition_unit, foreign_key: true
      t.string :custom_title

      t.timestamps
    end
  end
end
