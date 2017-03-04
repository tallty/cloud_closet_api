class AddDescriptionToGarment < ActiveRecord::Migration[5.0]
  def change
  	add_column :garments, :description, :text
  end
end
