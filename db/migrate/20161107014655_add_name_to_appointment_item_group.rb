class AddNameToAppointmentItemGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :appointment_item_groups, :type_name, :string
  end
end
