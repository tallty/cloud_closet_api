class CreatePurchaseLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_logs do |t|
      t.string :type
      t.string :operation
      t.float :change
      t.string :payment_method

      t.timestamps
    end
  end
end
