class AddRankToVipLevel < ActiveRecord::Migration[5.0]
  def change
    add_column :vip_levels, :rank, :integer
  end
end
