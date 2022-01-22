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
end
