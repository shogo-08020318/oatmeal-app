class CreateFoods < ActiveRecord::Migration[6.1]
  def change
    create_table :foods do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :image
      t.text :recipe, null: false
      t.text :cooking_comment
      t.integer :cooking_time, null: false
      t.integer :cooking_time_unit, null: false
      t.integer :serving, null: false
      t.string :uuid, null: false

      t.timestamps
    end
  end
end
