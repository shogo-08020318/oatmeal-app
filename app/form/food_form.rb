class FoodForm
  include ActiveModel::Model
  require 'google/cloud/translate'

  DEFAULT_INGREDIENT_COUNT = 3

  attr_accessor :name, :image, :recipe, :cooking_comment, :cooking_time, :cooking_time_unit, :serving, :user_id, :food_tags, :food_id, :tag_id, :ingredients, :ingredient_name, :quantity, :proper_quantity

  validate :food_validate
  validate :ingredient_validate

  def initialize(attributes = nil, food: Food.new, food_tag: FoodTag.new)
    @food = food
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

      # 翻訳する値を格納する配列
      @translate_array = []

      ingredients.each do |ingredient|
        food_ingredient = food.ingredients.build(ingredient_params(ingredient))
        food_ingredient.save!

        # 翻訳に使う値を取り出して格納
        @translate_array.push(food_ingredient[:ingredient_name], food_ingredient[:quantity])
      end

      # 翻訳する処理を実行
      translated_ingredients = google_translation(@translate_array)

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

  def google_translation(*ingredients)
    project_id = Rails.application.credentials.google[:CLOUD_PROJECT_ID]
    translate = Google::Cloud::Translate.new version: :v2, project_id: project_id
    target = 'en'
    text = ingredients
    translation = translate.translate(text, to: target)

    @translated_ingredients = []
    translation.each_slice(2) do |a, b|
      translated_ingredient = []
      translated_ingredient.push(a.text, b.text)
      @translated_ingredients << translated_ingredient
    end
    @translated_ingredients
  end
end
