class AddNumberAliasToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :number_alias, :string
  end
end
