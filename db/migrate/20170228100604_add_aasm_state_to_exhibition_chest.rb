class AddAasmStateToExhibitionChest < ActiveRecord::Migration[5.0]
  def change
    add_column :exhibition_chests, :aasm_state, :string
  end
end
