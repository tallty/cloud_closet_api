class AddStoreModeToGarment < ActiveRecord::Migration[5.0]
  def change
    add_column :garments, :stroe_mode, :string
  end
end
