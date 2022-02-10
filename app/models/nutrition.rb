class Nutrition < ApplicationRecord
  belongs_to :food

  with_options presence: true do
    validates :calories
    validates :carbo
    validates :fiber
    validates :protein
    validates :fat
  end

  def calorie_calculates(serving)
    macro_calories = [
      carbo * 4 / serving,
      protein * 4 / serving,
      fat * 9 / serving
    ]
    self.calories /= serving
    results = []
    macro_calories.each { |calorie| results << (calorie / calories * 100).round(1) }
    results << calories.to_i
  end

  def nutrition_calculates(serving)
    [
      self.carbo /= serving,
      self.protein /= serving,
      self.fat /= serving
    ]
  end
end
