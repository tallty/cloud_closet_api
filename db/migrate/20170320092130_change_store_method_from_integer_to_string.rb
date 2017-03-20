class ChangeStoreMethodFromIntegerToString < ActiveRecord::Migration[5.0]
  def change
  	change_column :exhibition_units, :store_method, :string
  end
end
