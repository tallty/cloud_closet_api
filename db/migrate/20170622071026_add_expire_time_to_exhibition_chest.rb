class AddExpireTimeToExhibitionChest < ActiveRecord::Migration[5.0]
  def change
    add_column :exhibition_chests, :expire_time, :datetime
  end
end
