class FoodSearchForm
  include ActiveModel::Model

  attr_accessor :name, :ingredient_name, :not_ingredient_name, :over_calories, :under_calories, :over_carbo, :under_carbo, :over_protein, :under_protein, :over_fat, :under_fat, :food_tags

  def search
    foods = Food.distinct.joins(:ingredients, :nutrition)

    # レシピ名と材料名から検索
    foods = foods.in_name(name).or(foods.in_ingredients(name)) if name.present?

    # 材料名のみで検索
    foods = foods.in_ingredients(ingredient_name) if ingredient_name.present?

    # 特定の材料を除外
    foods = foods.not_ingredients(not_ingredient_name) if not_ingredient_name.present?

    # カロリー検索（以上）
    foods = foods.over_calories(over_calories) if over_calories.present?

    # カロリー検索（以下）
    foods = foods.under_calories(under_calories) if under_calories.present?

    # 炭水化物検索（以上）
    foods = foods.over_carbo(over_carbo) if over_carbo.present?

    # 炭水化物検索（以下）
    foods = foods.under_carbo(under_carbo) if under_carbo.present?

    # たんぱく質検索（以上）
    foods = foods.over_protein(over_protein) if over_protein.present?

    # たんぱく質検索（以下）
    foods = foods.under_protein(under_protein) if under_protein.present?

    # 脂質検索（以上）
    foods = foods.over_fat(over_fat) if over_fat.present?

    # 脂質検索（以下）
    foods = foods.under_fat(under_fat) if under_fat.present?

    foods
  end
end
