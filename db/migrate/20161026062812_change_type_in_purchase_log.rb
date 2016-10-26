class ChangeTypeInPurchaseLog < ActiveRecord::Migration[5.0]
  def change
  	rename_column :purchase_logs, :type, :operation_type
  end
end
