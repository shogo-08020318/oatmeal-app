class Nutrition < ApplicationRecord
  belongs_to :food

  with_options presence: true do
    validates :calories
    validates :carbo
    validates :fiber
    validates :protein
    validates :fat
  end
end
