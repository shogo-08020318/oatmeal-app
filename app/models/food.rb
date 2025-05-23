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
    # 何人前か上限と下限を指定（整数で1〜10）
    validates :serving, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  end

  # 投稿の保存直前にuuidを生成
  before_create -> { self.uuid = SecureRandom.uuid }

  # 調理時間の単位
  enum cooking_time: { under_five_minutes: 10, ten_minutes: 20, thirty_minutes: 30, one_hour: 40, overnight: 50 }, _prefix: :cooking_time  

  # レシピ名に限定
  scope :in_name, ->(name) { where('name LIKE ?', "%#{name}%") }
  # 材料名に限定
  scope :in_ingredients, ->(name) { where('ingredients.ingredient_name like ?', "%#{name}%") }
  # 特定の材料を含まない
  scope :not_ingredients, ->(not_ingredient_name) { where.not(id: Ingredient.distinct.where('ingredient_name like ?', "%#{not_ingredient_name}%").pluck(:food_id)) }
  # カロリーで検索（以上）
  scope :over_calories, ->(over_calories) { where('nutritions.calories / serving >= ?', over_calories) }
  # カロリーで検索（以下）
  scope :under_calories, ->(under_calories) { where('nutritions.calories / serving <= ?', under_calories) }
  # 炭水化物で検索（以上）
  scope :over_carbo, ->(over_carbo) { where('nutritions.carbo / serving >= ?', over_carbo) }
  # 炭水化物で検索（以下）
  scope :under_carbo, ->(under_carbo) { where('nutritions.carbo / serving <= ?', under_carbo) }
  # たんぱく質で検索（以上）
  scope :over_protein, ->(over_protein) { where('nutritions.protein / serving >= ?', over_protein) }
  # たんぱく質で検索（以下）
  scope :under_protein, ->(under_protein) { where('nutritions.protein / serving <= ?', under_protein) }
  # 脂質で検索（以上）
  scope :over_fat, ->(over_fat) { where('nutritions.fat / serving >= ?', over_fat) }
  # 脂質で検索（以下）
  scope :under_fat, ->(under_fat) { where('nutritions.fat / serving <= ?', under_fat) }

  # 関連するレシピの取得
  def relevance
    # 関連するレシピを格納
    relevance_foods = []
    # そのレシピのタグをランダムで使って同じタグを含むレシピを取得
    relevance_foods << Food.distinct.joins(:tags).where.not(id: id).where(tags: { id: tag_ids.sample }).sample(6) if tags.present?

    # 上記で取得したレシピの数が5個未満なら材料を使って5個になるように追加
    # そのレシピ自身は除外、同じ材料を使って関連するレシピを取得
    relevance_foods << Food.distinct.joins(:ingredients).where.not(id: id).where(ingredients: { ingredient_name: (ingredients.pluck(:ingredient_name) - ['オートミール']).sample }).sample(6 - relevance_foods.count) if relevance_foods.flatten!.count <= 5

    relevance_foods.flatten!
  end
end
