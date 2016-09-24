class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string :title
      t.string :photo_type
      t.attachment :photo
      t.references :imageable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
