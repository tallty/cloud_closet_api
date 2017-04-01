class CreateUserMsgs < ActiveRecord::Migration[5.0]
  def change
    create_table :user_msgs do |t|
      t.string :title
      t.string :abstract
      t.string :url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
