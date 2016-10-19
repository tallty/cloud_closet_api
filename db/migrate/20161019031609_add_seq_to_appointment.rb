class AddSeqToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :seq, :string
  end
end
