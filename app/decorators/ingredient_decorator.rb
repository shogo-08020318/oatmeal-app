class IngredientDecorator < Draper::Decorator
  delegate_all

  def proper_quantity?
    quantity.present? ? quantity : '適量'
  end
end
