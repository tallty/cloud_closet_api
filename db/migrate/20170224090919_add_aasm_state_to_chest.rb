class AddAasmStateToChest < ActiveRecord::Migration[5.0]
  def change
    add_column :chests, :aasm_state, :string
  end
end
