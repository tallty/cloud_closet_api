class CreateOfflineRecharges < ActiveRecord::Migration[5.0]
  def change
    create_table :offline_recharges do |t|
      t.float :amount
      t.float :credit
      
      t.references :worker, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :is_confirmed#, default: false
      t.timestamps
    end
  end
end
