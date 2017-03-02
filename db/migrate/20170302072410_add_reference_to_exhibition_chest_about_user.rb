class AddReferenceToExhibitionChestAboutUser < ActiveRecord::Migration[5.0]
  def change
  	add_reference :exhibition_chests, :user, foreign_key: true
  end
end
