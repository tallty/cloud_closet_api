class AddSeqToDeliveryOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :delivery_orders, :seq, :string
  end
end
