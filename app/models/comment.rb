class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :food

  # コメントの本文は必須とし、文字数の上限を140文字とする
  validates :body, presence: true, length: { maximum: 140 }
end
