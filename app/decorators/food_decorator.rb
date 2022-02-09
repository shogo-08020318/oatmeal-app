class FoodDecorator < ApplicationDecorator
  delegate_all

  def cooking_comment?
    cooking_comment.present? ? cooking_comment : 'なし'
  end
end
