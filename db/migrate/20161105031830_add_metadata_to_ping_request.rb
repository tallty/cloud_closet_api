class AddMetadataToPingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :ping_requests, :metadata, :string
  end
end
