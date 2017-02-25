class ChangeAppointmentItemGroupsColumns < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointment_item_groups, :is_chest, :boolean
  	add_column :appointment_item_groups, :count_info, :string
  	
  	remove_column :appointment_item_groups, :season, :string
  	remove_column :appointment_item_groups, :count, :integer
  end
end
