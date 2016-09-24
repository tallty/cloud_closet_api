class CreateGarments < ActiveRecord::Migration[5.0]
  def change
    create_table :garments do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.datetime :put_in_time
      t.datetime :expire_time

      t.timestamps
    end
  end
end
