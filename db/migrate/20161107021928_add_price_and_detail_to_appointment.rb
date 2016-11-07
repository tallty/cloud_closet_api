class AddPriceAndDetailToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :price, :float, default: 0.00
    add_column :appointments, :detail, :string
  end
end
