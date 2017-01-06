class AddPriceToChests < ActiveRecord::Migration[5.0]
  def change
  	add_column :chests, :price, :float, default: 0.00
  end
end
