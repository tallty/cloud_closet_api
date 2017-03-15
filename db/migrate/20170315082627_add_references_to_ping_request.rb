class AddReferencesToPingRequest < ActiveRecord::Migration[5.0]
  def change
    add_reference :ping_requests, :user, foreign_key: true
  end
end
