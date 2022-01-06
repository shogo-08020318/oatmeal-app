class FoodTagForm
  include ActiveModel::Model

  attr_accessor :name, :image, :recipe, :cooking_comment, :cooking_time, :cooking_time_unit, :serving, :user_id, :food_tags, :food_id, :tag_id

  with_options presence: true do
    validates :name
    # 作り方の文字数を制限
    validates :recipe, length: { maximum: 528 }
    validates :cooking_time
    validates :cooking_time_unit
    # 何人前か上限と下限を指定（整数で1〜10）
    validates :serving, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  end

  def save
    ActiveRecord::Base.transaction do
      food = Food.new(food_params)
      food.save

      food_tags.each do |food_tag|
        food.food_tags.create(tag_id: food_tag)
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
end
