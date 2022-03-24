class NutritionDecorator < ApplicationDecorator
  delegate_all

  def nutrition_check
    calories.zero?
  end
end
