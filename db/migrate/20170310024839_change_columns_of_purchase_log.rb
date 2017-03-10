class ChangeColumnsOfPurchaseLog < ActiveRecord::Migration[5.0]
  def up
  	add_column :purchase_logs, :amount, :float
  	add_column :purchase_logs, :is_increased, :boolean

  	remove_column :purchase_logs, :change, :float
  	remove_column :purchase_logs, :operation_type, :string
  end

  def down
  	remove_column :purchase_logs, :amount, :float
  	remove_column :purchase_logs, :is_increased, :boolean

  	add_column :purchase_logs, :change, :float
  	add_column :purchase_logs, :operation_type, :string
  end
end
