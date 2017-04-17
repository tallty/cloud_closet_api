class RemoveAasmStateFromGarment < ActiveRecord::Migration[5.0]
  def change
    remove_column :garments, :aasm_state, :string
  end
end
