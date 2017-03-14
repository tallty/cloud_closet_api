class AddCreditAndActualAmountToPurchaseLog < ActiveRecord::Migration[5.0]
  def change
    add_column :purchase_logs, :credit, :integer, default: 0
    add_column :purchase_logs, :actual_amount, :float, default: 0
  end
end
