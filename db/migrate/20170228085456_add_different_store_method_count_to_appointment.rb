class AddDifferentStoreMethodCountToAppointment < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointments, :garment_count_info, :string
  	add_column :appointments, :hanging_count, :integer, default: 0
  	add_column :appointments, :stacking_count, :integer, default: 0
  	add_column :appointments, :full_dress_count, :integer, default: 0
  end
end
