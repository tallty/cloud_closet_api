class AddAasmToGarment < ActiveRecord::Migration[5.0]
  def change
  	change_table :garments do |t|
    	t.string :aasm_state
  	end
  end
end
