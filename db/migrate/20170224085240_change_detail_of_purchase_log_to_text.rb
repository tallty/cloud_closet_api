class ChangeDetailOfPurchaseLogToText < ActiveRecord::Migration[5.0]
  def change
  	change_column :purchase_logs, :detail, :text
  end
end
