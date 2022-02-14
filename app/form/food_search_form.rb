class FoodSearchForm
  include ActiveModel::Model

  attr_accessor :name

  def search
    foods = Food.distinct.joins(:ingredients)

    # レシピ名と材料名から検索
    foods.in_name(name).or(foods.in_ingredients(name))
  end
end
