class FoodsController < ApplicationController
  def index
    @foods = Food.all.includes(:user).order(created_at: :desc)
  end

  def new
    @food = current_user.foods.build
  end

  def create
    @food = current_user.foods.build(food_params)
    if @food.save
      redirect_to foods_path, success: t('.success')
    else
      flash[:danger] = t('.fail')
      render :new
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, :recipe, :image, :cooking_comment, :cooking_time, :cooking_time_unit, :serving)
  end
end
