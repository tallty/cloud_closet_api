class AddBalanceToPurchaseLog < ActiveRecord::Migration[5.0]
  def change
    add_column :purchase_logs, :balance, :float
  end
end
