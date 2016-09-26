class AddOpenidToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :openid, :string
    add_index :users, :openid
  end
end
