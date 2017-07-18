class AddApptTypeToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :appt_type, :string, index: true
  end
end
