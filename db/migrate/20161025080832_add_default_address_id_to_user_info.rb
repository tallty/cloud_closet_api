class AddDefaultAddressIdToUserInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :user_infos, :default_address_id, :integer
  end
end
