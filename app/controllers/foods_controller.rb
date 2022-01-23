class FoodsController < ApplicationController
  def index
    @foods = Food.all.includes(:user, :tags).order(created_at: :desc)
  end

  def show
    @food = Food.find_by(uuid: params[:uuid])
  end

  def new
    @form = FoodForm.new
  end

  def create
    @form = FoodForm.new(food_params)
    if @form.save
      redirect_to foods_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  private

  def food_params
    params.require(:food_form).permit(:name, :recipe, :image, :cooking_comment, :cooking_time, :cooking_time_unit, :serving, { food_tags: [] }, ingredients_attributes: %i[ingredient_name quantity proper_quantity]).merge(user_id: current_user.id)
  end
end
