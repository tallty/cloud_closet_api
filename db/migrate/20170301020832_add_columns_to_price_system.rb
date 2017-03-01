class AddColumnsToPriceSystem < ActiveRecord::Migration[5.0]
  def change
    add_column :price_systems, :description, :text
    add_column :price_systems, :unit_name, :string
  end
end
