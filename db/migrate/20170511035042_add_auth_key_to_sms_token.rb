class AddAuthKeyToSmsToken < ActiveRecord::Migration[5.0]
  def change
    add_column :sms_tokens, :auth_key, :string
  end
end
