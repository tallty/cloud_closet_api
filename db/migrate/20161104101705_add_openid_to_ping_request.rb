class AddOpenidToPingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :ping_requests, :openid, :string
  end
end
