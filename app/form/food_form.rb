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
          food.food_tags.create!(tag_id: food_tag)
        end
      end

      # 翻訳する値を格納する配列
      @translate_array = []

      ingredients.each do |ingredient|
        food_ingredient = food.ingredients.create!(ingredient_params(ingredient))
        food_ingredient.save!
        # 翻訳に使う値を取り出して格納
        @translate_array.push(food_ingredient[:quantity], food_ingredient[:ingredient_name])
      end

      # 翻訳する処理を実行
      translated_ingredients = google_translation(@translate_array)
      # 翻訳したデータを使ってマクロ栄養素を算出
      nutrition_data = nutrition_calculate(translated_ingredients)
      # 投稿されたレシピのマクロ栄養素として保存
      food.create_nutrition!(nutrition_data)

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
      @translated_ingredients << translated_ingredient.join('%20')
    end
    @translated_ingredients
  end

  def nutrition_calculate(ingredients)
    app_id = Rails.application.credentials.edamam[:app_id]
    app_key = Rails.application.credentials.edamam[:app_key]
    ingr = ingredients.join('%20and%20')
    url = URI.parse("https://api.edamam.com/api/nutrition-data?app_id=#{app_id}&app_key=#{app_key}&ingr=#{ingr}")
    response = Net::HTTP.get_response(url)
    response_body = JSON.parse(response.body)
    {
      calories: response_body['totalNutrients']['ENERC_KCAL']['quantity'],
      carbo: response_body['totalNutrients']['CHOCDF']['quantity'],
      fiber: response_body['totalNutrients']['FIBTG']['quantity'],
      protein: response_body['totalNutrients']['PROCNT']['quantity'],
      fat: response_body['totalNutrients']['FAT']['quantity']
    }
  end
end
