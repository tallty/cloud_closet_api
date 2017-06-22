class AddMaxCountToExhibitionChest < ActiveRecord::Migration[5.0]
  def change
    add_column :exhibition_chests, :max_count, :integer
  end
end
