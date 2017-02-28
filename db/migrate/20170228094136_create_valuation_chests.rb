class CreateValuationChests < ActiveRecord::Migration[5.0]
  def change
    create_table :valuation_chests do |t|
      t.references :price_system, foreign_key: true
      t.string :aasm_state
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
