class User < ApplicationRecord
  authenticates_with_sorcery!

  # ユーザーが複数の投稿を所持する
  has_many :foods, dependent: :destroy

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
  validates :email, { presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } }

  # ユーザー名は必須項目、上限20文字
  validates :name, presence: true, length: { maximum: 20 }

  # ユーザーの権限
  enum role: { general: 0, admin: 1 }

  # ユーザー保存直前にuuidを生成
  before_create -> { self.uuid = SecureRandom.uuid }
end
