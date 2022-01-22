class CreateNutritions < ActiveRecord::Migration[6.1]
  def change
    create_table :nutritions do |t|
      t.references :food, null: false, foreign_key: true
      t.float :calories, null: false
      t.float :carbo, null: false
      t.float :fiber, null: false
      t.float :protein, null: false
      t.float :fat, null: false

      t.timestamps
    end
  end
end
