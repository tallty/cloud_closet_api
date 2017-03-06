class CreateRechargeRules < ActiveRecord::Migration[5.0]
  def change
    create_table :recharge_rules do |t|
      t.float :amount
      t.float :credits, default: 0

      t.timestamps
    end
  end
end
