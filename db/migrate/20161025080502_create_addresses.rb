class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.references :user_info, foreign_key: true
      t.string :name
      t.string :address_detail
      t.string :phone

      t.timestamps
    end
  end
end
