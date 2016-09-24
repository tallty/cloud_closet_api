class CreateDistributionItems < ActiveRecord::Migration[5.0]
  def change
    create_table :distribution_items do |t|
      t.references :distribution, foreign_key: true
      t.references :garment, foreign_key: true
      t.float :price
      t.integer :status

      t.timestamps
    end
  end
end
