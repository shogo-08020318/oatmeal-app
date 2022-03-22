class User < ApplicationRecord
  authenticates_with_sorcery!

  # アップローダークラスとモデルの紐付け
  mount_uploader :avatar, AvatarUploader

  # ユーザーが複数の投稿を所持する
  has_many :foods, dependent: :destroy

  # ユーザーは複数の投稿をお気に入り登録することができる
  has_many :favorites, dependent: :destroy

  # お気に入り登録している
  has_many :favorite_foods, through: :favorites, source: :food

  # ユーザーはコメントを複数作成できる
  has_many :comments, dependent: :destroy

  # twitter認証用
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  # パスワードは半角アルファベット（大文字・小文字・数値）
  VALID_PASSWORD_REGEX = /\A[a-zA-Z0-9]+\z/.freeze

  validates :password, length: { minimum: 6 }, format: { with: VALID_PASSWORD_REGEX }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  # 入力されたメールアドレスを全て小文字にする（メールアドレスは大小を区別しないため）
  before_save { self.email = email.downcase }
  # メールアドレスのフォーマットを確認
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  # メールアドレスは必須項目かつ一意、大文字小文字の区別を無効にしフォーマットと一致しているか確認
  # メールアドレス認証、twitter認証共通のバリデーション → emailは必須項目
  validates :email, presence: true
  # twitter_idが存在する → emailのフォーマットはチェックしない、twitter_idが存在しない → emailのフォーマットをチェックする
  validates :email, { format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, if: :twitter_user_check }

  # ユーザー名は必須項目、上限20文字
  validates :name, presence: true, length: { maximum: 20 }

  # ユーザーの権限
  enum role: { general: 0, admin: 1 }

  # ユーザー保存直前にuuidを生成
  before_create -> { self.uuid = SecureRandom.uuid }

  # レシピが自分のものか判別
  def mine?(object)
    id == object.user_id
  end

  # お気に入り登録する
  def favorite(food)
    favorite_foods << food
  end

  # お気に入り登録を解除する
  def unfavorite(food)
    favorite_foods.destroy(food)
  end

  # お気に入り登録されているか判別
  def favorite?(food)
    favorite_foods.include?(food)
  end
end

# emailのフォーマットをチェックするか判断するためのメソッド
def twitter_user_check
  # twitter_idが存在するならemailのフォーマットのチェックはしない
  return false if twitter_id.present?

  true
end
