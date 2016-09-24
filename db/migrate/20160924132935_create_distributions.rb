class CreateDistributions < ActiveRecord::Migration[5.0]
  def change
    create_table :distributions do |t|
      t.string :address
      t.string :name
      t.string :phone
      t.date :date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
