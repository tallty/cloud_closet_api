class CreatePublicMsgs < ActiveRecord::Migration[5.0]
  def change
    create_table :public_msgs do |t|
      t.string :title
      t.string :abstract
      t.text :content

      t.timestamps
    end
  end
end
