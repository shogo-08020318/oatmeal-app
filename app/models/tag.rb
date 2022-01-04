class Tag < ApplicationRecord
  # tagはfoodとの関係を複数持ち、tagが削除されればそのtagのidを持つレコーも削除
  has_many :food_tags, dependent: :destroy
  # tagは複数のfoodに使われる
  has_many :foods, through: :food_tags
end
