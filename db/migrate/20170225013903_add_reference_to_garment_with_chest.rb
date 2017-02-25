class AddReferenceToGarmentWithChest < ActiveRecord::Migration[5.0]
  def change
  	add_reference :garments, :chest, foreign_key: true
  end
end
