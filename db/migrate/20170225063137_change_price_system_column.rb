class ChangePriceSystemColumn < ActiveRecord::Migration[5.0]
  def change
  	add_column :price_systems, :max_count_info, :string
  	add_column :price_systems, :is_chest, :boolean
  	
  	remove_column :price_systems, :max_count_per, :integer
  	remove_column :price_systems, :item_type, :integer
  end
end
