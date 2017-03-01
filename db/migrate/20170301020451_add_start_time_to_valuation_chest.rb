class AddStartTimeToValuationChest < ActiveRecord::Migration[5.0]
  def change
    add_column :valuation_chests, :start_time, :date
  end
end
