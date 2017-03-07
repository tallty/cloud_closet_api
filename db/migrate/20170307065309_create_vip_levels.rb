class CreateVipLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :vip_levels do |t|
      t.string :name
      t.integer :xp
      t.integer :birthday_gift

      t.timestamps
    end
  end
end
