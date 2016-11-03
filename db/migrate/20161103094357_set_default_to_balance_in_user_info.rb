class SetDefaultToBalanceInUserInfo < ActiveRecord::Migration[5.0]
  def change
  	change_column :user_infos, :balance, :float, :default => 0.00
  end
end
