class CreateStoreMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :store_methods do |t|
      t.string :title
      t.string :zh_title

      t.timestamps
    end
  end
end
