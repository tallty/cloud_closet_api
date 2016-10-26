class AddReferenceToPurchaseLog < ActiveRecord::Migration[5.0]
  def change
    add_reference :purchase_logs, :user_info, foreign_key: true
  end
end
