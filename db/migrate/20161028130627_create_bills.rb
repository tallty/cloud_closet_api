class CreateBills < ActiveRecord::Migration[5.0]
  def change
    create_table :bills do |t|
      t.decimal :amount
      t.integer :bill_type,default: 0
      t.string :seq
      t.string :sign
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
