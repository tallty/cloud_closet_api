class ChangeColumnNameOfStroeModeInGarment < ActiveRecord::Migration[5.0]
  def change
  	rename_column :garments, :stroe_mode, :store_method
  end
end
