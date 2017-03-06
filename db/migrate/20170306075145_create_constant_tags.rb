class CreateConstantTags < ActiveRecord::Migration[5.0]
  def change
    create_table :constant_tags do |t|
      t.string :title
      t.integer :class_type

      t.timestamps
    end
  end
end
