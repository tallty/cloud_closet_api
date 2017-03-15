class AddCanArrearsToPurchaseLog < ActiveRecord::Migration[5.0]
  def change
    add_column :purchase_logs, :can_arrears, :boolean
  end
end
