class CreateDeliveryOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :delivery_orders do |t|
      t.string :address
      t.string :name
      t.string :phone
      t.date :delivery_time
      t.string :delivery_method
      t.string :remark
      t.integer :delivery_cost
      t.integer :service_cost
      t.string :aasm_state
      t.string :garment_ids
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
