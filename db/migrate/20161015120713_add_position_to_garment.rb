class AddPositionToGarment < ActiveRecord::Migration[5.0]
  def change
    add_column :garments, :row, :integer
    add_column :garments, :carbit, :integer
    add_column :garments, :place, :integer
  end
end
