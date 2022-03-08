class Favorite < ApplicationRecord
  # モデルの作成時にuser:referencesを使用したため自動で記述された
  belongs_to :user
  belongs_to :food

  # userとfoodの組み合わせは一意である
  validates :user_id, uniqueness: { scope: :food_id }
end
