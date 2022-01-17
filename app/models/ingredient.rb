class Ingredient < ApplicationRecord
  belongs_to :food

  validates :ingredient_name, presence: true

  validate :quantity_or_proper_quantity_check

  private

  # quantityとproper_quantityのどちらか入力した場合しか許可しない
  def quantity_or_proper_quantity_check
    return if (quantity.present?) ^ (proper_quantity == true)

    errors.add(:quantity, 'は分量を入力するか適量用のチェックボックスを選択するかどちらか片方にしてください')
  end
end
