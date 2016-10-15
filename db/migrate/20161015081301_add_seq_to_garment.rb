class AddSeqToGarment < ActiveRecord::Migration[5.0]
  def change
    add_column :garments, :seq, :string
    add_index :garments, :seq
  end
end
