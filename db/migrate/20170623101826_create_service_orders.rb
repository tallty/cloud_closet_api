class CreateServiceOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :service_orders do |t|
      t.references :user, foreign_key: true
      t.float :rent
      t.float :care_cost
      t.float :service_cost
      t.string :operation

      t.timestamps
    end
  end
end
