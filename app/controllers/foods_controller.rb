class FoodsController < ApplicationController
  def index
    @foods = Food.all.includes(:user).order(created_at: :desc)
  end

  def new
    @form = FoodTagForm.new
  end

  def create
    @form = FoodTagForm.new(food_params)
    if @form.save
      redirect_to foods_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  private

  def food_params
    params.require(:food_tag_form).permit(:name, :recipe, :image, :cooking_comment, :cooking_time, :cooking_time_unit, :serving, { food_tags: [] }).merge(user_id: current_user.id)
  end
end
