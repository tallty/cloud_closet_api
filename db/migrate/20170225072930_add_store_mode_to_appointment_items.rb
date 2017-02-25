class AddStoreModeToAppointmentItems < ActiveRecord::Migration[5.0]
  def change
    add_column :appointment_items, :store_mode, :string
  end
end
