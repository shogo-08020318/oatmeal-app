class RenameNameColumnToIngredients < ActiveRecord::Migration[6.1]
  def change
    rename_column :ingredients, :name, :ingredient_name
  end
end
