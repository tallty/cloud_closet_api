class ChangeTypeOfCreditInOfflineRecharge < ActiveRecord::Migration[5.0]
  def change
  	change_column :offline_recharges, :credit, :integer
  end
end
