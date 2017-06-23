class AddReferenceFromAppointmentPriceGroupToServiceOrder < ActiveRecord::Migration[5.0]
  def change
    add_reference :appointment_price_groups, :service_order, foreign_key: true
  end
end
