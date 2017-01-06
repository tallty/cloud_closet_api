class AddColumnToAddress < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :house_number, :string
    add_column :addresses, :sex, :integer
  end
end
