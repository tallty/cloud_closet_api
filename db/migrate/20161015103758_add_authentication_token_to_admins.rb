class AddAuthenticationTokenToAdmins < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :authentication_token, :string, limit: 30
    add_index :admins, :authentication_token, unique: true
  end
end
