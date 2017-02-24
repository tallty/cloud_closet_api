class ChangeAppointmentColumn < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointments, :remark, :text
  	add_column :appointments, :care_type, :string
  	add_column :appointments, :care_cost, :float
  	add_column :appointments, :service_cost, :float
  	add_column :appointments, :rent_charge, :float
  end
end
