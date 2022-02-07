class FoodForm
  include ActiveModel::Model
  require 'google/cloud/translate'

  attr_accessor :food, :name, :image, :recipe, :cooking_comment, :cooking_time, :cooking_time_unit, :serving, :user_id, :food_tags, :food_id, :tag_id, :ingredients, :ingredient_name, :quantity, :proper_quantity

  validate :food_validate
  validate :ingredient_validate

  delegate :persisted?, to: :@food

  def initialize(attributes = nil, food: Food.new)
    @food = food
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      food = Food.create!(food_params)
      # タグのidを渡す
      food.tag_ids = food_tags
      # 材料の作成とマクロ栄養素の計算
      ingredients_and_nutrition(food)
      true
    end
  rescue StandardError => e
    p e
    false
  end

  def update
    return false if invalid?

    ActiveRecord::Base.transaction do
      # パラメータを一度別の変数に代入
      food_form_params = food_params
      # 送信されたパラメータにimageが存在しなければ元の画像のデータを渡す
      # imageのパラメータが送信されればその値が使われる
      food_form_params[:image] = food.image if food_params[:image].nil?
      food.update!(food_form_params)
      food.tag_ids = food_tags
      food.ingredients.destroy_all
      ingredients_and_nutrition(food)

      true
    end
  rescue StandardError => e
    p e
    false
  end

  def to_model
    @food
  end

  private

  def default_attributes
    {
      name: @food.name,
      image: @food.image,
      recipe: @food.recipe,
      cooking_comment: @food.cooking_comment,
      cooking_time: @food.cooking_time,
      cooking_time_unit: @food.cooking_time_unit,
      serving: @food.serving,
      food_tags: @food.tags,
      ingredients: @food.ingredients
    }
  end

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
      ingredient = food.ingredients.build(i)
      next if ingredient.valid?

      ingredient.errors.each do |at, er|
        errors.add(at, er)
      end
    end
    errors.uniq!
  end

  def ingredients_and_nutrition(food)
    # 翻訳する値を格納する配列
    translate_array = []
    ingredients.each do |ingredient|
      # ingredientは、{"ingredient_name"=>"砂糖", "quantity"=>"", "proper_quantity"=>"true"} or {"ingredient_name"=>"ヨーグルト", "quantity"=>"30g"} のようか形で入っている
      food_ingredient = food.ingredients.create!(ingredient)
      # 翻訳に使う値を取り出して格納
      translate_array.push(food_ingredient[:quantity], food_ingredient[:ingredient_name]) if food_ingredient[:quantity].present?
    end

    # 翻訳する処理を実行
    translated_ingredients = google_translation(translate_array)
    # 翻訳したデータを使ってマクロ栄養素を算出
    nutrition_data = nutrition_calculate(translated_ingredients)
    # 投稿されたレシピのマクロ栄養素として保存
    food.create_nutrition!(nutrition_data)
  end

  def google_translation(*ingredients)
    project_id = Rails.application.credentials.google[:CLOUD_PROJECT_ID]
    translate = Google::Cloud::Translate.new version: :v2, project_id: project_id, credentials: Rails.application.credentials.google[:SERVICE_ACCOUNT]
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
