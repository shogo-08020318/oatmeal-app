class Food < ApplicationRecord
  # アップローダークラスとモデルの紐付け
  mount_uploader :image, ImageUploader

  belongs_to :user

  # foodはtagとの関係を複数持ち、foodが削除されればそのfoodのidを持つレコードも削除
  has_many :food_tags, dependent: :destroy
  # tagとはfood_tagsを介してつながる
  has_many :tags, through: :food_tags
  # foodはingredientsとの関係を複数持ち、foodが削除されればそのfoodのidを持つレコードも削除
  has_many :ingredients, dependent: :destroy

  # レシピは対して必ずマクロ栄養素のデータを持つ
  has_one :nutrition, dependent: :destroy

  # foodは複数お気に入り登録される
  has_many :favorites, dependent: :destroy

  # レシピは複数のコメントを持つ
  has_many :comments, dependent: :destroy

  with_options presence: true do
    validates :name
    # 作り方の文字数を制限
    validates :recipe, length: { maximum: 528 }
    validates :cooking_time
    validates :cooking_time_unit
    # 何人前か上限と下限を指定（整数で1〜10）
    validates :serving, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  end

  # 調理時間の単位
  enum cooking_time_unit: { seconds: 0, minutes: 1, hours: 2 }

  # 投稿の保存直前にuuidを生成
  before_create -> { self.uuid = SecureRandom.uuid }

  # レシピ名に限定
  scope :in_name, ->(name) { where('name LIKE ?', "%#{name}%") }
  # 材料名に限定
  scope :in_ingredients, ->(name) { where('ingredients.ingredient_name like ?', "%#{name}%") }
  # 特定の材料を含まない
  scope :not_ingredients, ->(not_ingredient_name) { where.not(id: Ingredient.distinct.where('ingredient_name like ?', "%#{not_ingredient_name}%").pluck(:food_id)) }
  # カロリーで検索（以上）
  scope :over_calories, ->(over_calories) { where('nutritions.calories >= ?', over_calories) }
  # カロリーで検索（以下）
  scope :under_calories, ->(under_calories) { where('nutritions.calories <= ?', under_calories) }
  # 炭水化物で検索（以上）
  scope :over_carbo, ->(over_carbo) { where('nutritions.carbo >= ?', over_carbo) }
  # 炭水化物で検索（以下）
  scope :under_carbo, ->(under_carbo) { where('nutritions.carbo <= ?', under_carbo) }
  # たんぱく質で検索（以上）
  scope :over_protein, ->(over_protein) { where('nutritions.protein >= ?', over_protein) }
  # たんぱく質で検索（以下）
  scope :under_protein, ->(under_protein) { where('nutritions.protein <= ?', under_protein) }
  # 脂質で検索（以上）
  scope :over_fat, ->(over_fat) { where('nutritions.fat >= ?', over_fat) }
  # 脂質で検索（以下）
  scope :under_fat, ->(under_fat) { where('nutritions.fat <= ?', under_fat) }
end
