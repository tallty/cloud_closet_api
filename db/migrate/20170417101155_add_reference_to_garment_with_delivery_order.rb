class AddReferenceToGarmentWithDeliveryOrder < ActiveRecord::Migration[5.0]
  def change
  	add_reference :garments, :delivery_order, foreign_key: true
  end
end
