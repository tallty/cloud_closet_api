class AddDepositToUserInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :user_infos, :balance, :float
  end
end
