class AddCreditToPingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :ping_requests, :credit, :integer
  end
end
