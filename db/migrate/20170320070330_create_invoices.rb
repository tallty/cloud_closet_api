class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string :title
      t.float :amount
      t.string :type
      t.string :aasm_state
      t.string :cel_name
      t.string :cel_phone
      t.string :postcode
      t.string :address
      t.date :date
      t.float :blance
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
