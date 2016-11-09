class AddStatusToGarment < ActiveRecord::Migration[5.0]
  def change
    add_column :garments, :status, :string
  end
end
