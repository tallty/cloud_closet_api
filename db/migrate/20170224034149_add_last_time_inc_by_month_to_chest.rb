class AddLastTimeIncByMonthToChest < ActiveRecord::Migration[5.0]
  def change
    add_column :chests, :last_time_inc_by_month, :integer
  end
end
