class FoodSearchForm
  include ActiveModel::Model

  attr_accessor :name, :ingredient_name, :not_ingredient_name, :food_tags

  def search
    foods = Food.distinct.joins(:ingredients, :nutrition)

    # レシピ名と材料名から検索
    foods = foods.in_name(name).or(foods.in_ingredients(name))

    # 材料名のみで検索
    foods = foods.in_ingredients(ingredient_name)

    # 特定の材料を除外
    foods.not_ingredients(not_ingredient_name) if not_ingredient_name.present?
    foods
  end
end
