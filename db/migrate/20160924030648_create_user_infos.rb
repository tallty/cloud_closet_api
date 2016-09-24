class CreateUserInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :user_infos do |t|
      t.references :user, foreign_key: true
      t.string :nickname
      t.string :mail

      t.timestamps
    end
  end
end
