class AddDetailToPurchaseLog < ActiveRecord::Migration[5.0]
  def change
    add_column :purchase_logs, :detail, :string
  end
end
