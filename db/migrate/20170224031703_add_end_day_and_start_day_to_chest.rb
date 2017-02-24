class AddEndDayAndStartDayToChest < ActiveRecord::Migration[5.0]
  def change
    add_column :chests, :end_day, :date
    add_column :chests, :start_day, :date
  end
end
