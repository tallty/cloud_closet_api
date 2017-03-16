class ChangeColumnXpInVipLevels < ActiveRecord::Migration[5.0]
  def change
  	rename_column :vip_levels, :xp, :exp
  end
end
