class Food < ApplicationRecord
  # アップローダークラスとモデルの紐付け
  mount_uploader :image, ImageUploader

  belongs_to :user

  # foodはtagとの関係を複数持ち、foodが削除されればそのfoodのidを持つレコードも削除
  has_many :food_tags, dependent: :destroy
  # tagとはfood_tagsを介してつながる
  has_many :tags, through: :food_tags

  # 調理時間の単位
  enum cooking_time_unit: { seconds: 0, minutes: 1, hours: 2 }

  # 投稿の保存直前にuuidを生成
  before_create -> { self.uuid = SecureRandom.uuid }
end
