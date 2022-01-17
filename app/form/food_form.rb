class FoodForm
  include ActiveModel::Model

  DEFAULT_INGREDIENT_COUNT = 3

  attr_accessor :name, :image, :recipe, :cooking_comment, :cooking_time, :cooking_time_unit, :serving, :user_id, :food_tags, :food_id, :tag_id, :ingredients, :ingredient_name, :quantity, :proper_quantity

  validate :food_validate
  validate :ingredient_validate

  def initialize(attributes = nil, food_tag: FoodTag.new)
    @food_tag = food_tag
    self.ingredients = DEFAULT_INGREDIENT_COUNT.times.map { Ingredient.new } unless ingredients.present?
    super(attributes)
  end

  def ingredients_attributes=(attributes)
    self.ingredients = attributes.map do |_, ingredient_attribute|
      Ingredient.new(ingredient_attribute)
    end
  end

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      food = Food.new(food_params)
      food.save!

      if food_tags.present?
        food_tags.each do |food_tag|
          food.food_tags.create(tag_id: food_tag)
        end
      end

      ingredients.each do |ingredient|
        food_ingredient = food.ingredients.build(ingredient_params(ingredient))
        food_ingredient.save!
      end

      true
    end
  rescue StandardError => e
    p e
    false
  end

  private

  def food_params
    {
      name: name,
      image: image,
      recipe: recipe,
      cooking_comment: cooking_comment,
      cooking_time: cooking_time,
      cooking_time_unit: cooking_time_unit,
      serving: serving,
      user_id: user_id
    }
  end

  def ingredient_params(ingredient)
    {
      ingredient_name: ingredient.ingredient_name,
      quantity: ingredient.quantity,
      proper_quantity: ingredient.proper_quantity
    }
  end

  def food_validate
    food = Food.new(food_params)
    return if food.valid?

    food.errors.each do |at, er|
      errors.add(at, er)
    end
  end

  def ingredient_validate
    food = Food.new(food_params)
    ingredients.each do |i|
      ingredient = food.ingredients.build(ingredient_params(i))
      next if ingredient.valid?

      ingredient.errors.each do |at, er|
        errors.add(at, er)
      end
    end
    errors.uniq!
  end
end
