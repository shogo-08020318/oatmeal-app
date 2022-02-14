class FoodSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # attr_accessor :word
  attribute :name, :string

  def search
    foods = Food.all

    # レシピ名内で検索
    foods.in_name(name)
  end
end
