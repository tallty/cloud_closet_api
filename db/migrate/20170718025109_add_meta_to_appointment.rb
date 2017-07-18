class AddMetaToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :meta, :text
  end
end
