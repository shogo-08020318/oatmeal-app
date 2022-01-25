class Nutrition < ApplicationRecord
  belongs_to :food

  with_options presence: true do
    validates :calories
    validates :carbo
    validates :fiber
    validates :protein
    validates :fat
  end

  def calorie_calculates
    macro_calories = [carbo * 4, protein * 4, fat * 9]
    results = []
    macro_calories.each { |calorie| results << calorie / calories * 100 }
    results
  end
end
