class AddSeasonToAppointmentItemGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :appointment_item_groups, :season, :string
  end
end
