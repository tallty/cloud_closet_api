class AddReferenceToExhibitionChestWithValuationChest < ActiveRecord::Migration[5.0]
  def change
  	add_reference :exhibition_chests, :valuation_chest, foregin_key: true 
  end
end
