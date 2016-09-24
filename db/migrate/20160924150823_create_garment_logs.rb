class CreateGarmentLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :garment_logs do |t|
      t.references :garment, foreign_key: true
      t.string :title
      t.string :comment
      t.string :old_status
      t.string :status

      t.timestamps
    end
  end
end
