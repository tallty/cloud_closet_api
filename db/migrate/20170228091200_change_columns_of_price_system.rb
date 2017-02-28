class ChangeColumnsOfPriceSystem < ActiveRecord::Migration[5.0]
  def change
  	remove_column :price_systems, :max_count_info
  end
end
