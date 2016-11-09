class AddAasmStateToGarmentAndAppointmentItem < ActiveRecord::Migration[5.0]
  def change
    add_column :garments, :aasm_state, :string, default: 'storing'
    add_column :appointment_items, :aasm_state, :string, default: 'storing'
  end
end
