class ChangeBills < ActiveRecord::Migration[5.0]
  def change
  	change_table :bills do |t|
  	  t.remove :amount
  	  t.float :price, default: 0.00
  	end
  end
end
