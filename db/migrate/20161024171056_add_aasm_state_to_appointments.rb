class AddAasmStateToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :aasm_state, :string
  end
end
