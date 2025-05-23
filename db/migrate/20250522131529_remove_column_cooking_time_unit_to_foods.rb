class RemoveColumnCookingTimeUnitToFoods < ActiveRecord::Migration[6.1]
  def up
    remove_column :foods, :cooking_time_unit
  end

  def down
    add_column :foods, :cooking_time_unit, :integer, null: false
  end
end
