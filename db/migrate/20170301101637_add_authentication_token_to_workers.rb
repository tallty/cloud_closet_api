class AddAuthenticationTokenToWorkers < ActiveRecord::Migration[5.0]
  def change
    add_column :workers, :authentication_token, :string, limit: 30
    add_index :workers, :authentication_token, unique: true
  end
end
