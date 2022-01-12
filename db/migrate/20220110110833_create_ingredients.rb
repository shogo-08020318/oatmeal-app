class CreateIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients do |t|
      t.references :food, null: false, foreign_key: true
      t.string :name, null: false
      t.string :quantity
      t.boolean :proper_quantity, default: false

      t.timestamps
    end
  end
end
