class AddReferenceFromValuationChestToAppointmentPriceGroup < ActiveRecord::Migration[5.0]
  def change
  	add_reference :valuation_chests, :appointment_price_group, foregin_key: true
  end
end
