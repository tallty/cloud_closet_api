class ChangePriceSystem < ActiveRecord::Migration[5.0]
  def change
  	add_column :price_systems, :item_type, :integer
  	add_column :price_systems, :max_count_per, :integer
  	add_column :price_systems, :title, :string

  	remove_column :price_systems, :season, :string
  	remove_column :price_systems, :name, :string
  end
end
