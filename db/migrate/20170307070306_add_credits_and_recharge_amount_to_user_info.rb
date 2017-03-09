class AddCreditsAndRechargeAmountToUserInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :user_infos, :credits, :integer, default: 0
    add_column :user_infos, :recharge_amount, :integer, default: 0
  end
end
