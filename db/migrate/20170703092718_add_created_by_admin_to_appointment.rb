class AddCreatedByAdminToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :created_by_admin, :boolean
  end
end
