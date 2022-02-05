class FoodsController < ApplicationController
  before_action :get_food, only: %i[edit update destroy]
  skip_before_action :require_login, only: %i[index show]

  def index
    @foods = Food.all.includes(:user, :tags).order(created_at: :desc)
  end

  def show
    @food = Food.find_by(uuid: params[:uuid])
    gon.nutrition = @food.nutrition
    gon.nutrition_calories = @food.nutrition.calorie_calculates
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

  def edit
    @form = FoodForm.new(food: @food)
  end

  def update
    @form = FoodForm.new(food_params, food: @food)
    if @form.update
      redirect_to food_path(@food.uuid), success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :edit
    end
  end

  def destroy
    @food.destroy!
    redirect_to foods_path, success: t('.success')
  end

  private

  def food_params
    params.require(:food).permit(:name, :recipe, :image, :cooking_comment, :cooking_time, :cooking_time_unit, :serving, { food_tags: [] }, ingredients: %i[ingredient_name quantity proper_quantity]).merge(user_id: current_user.id)
  end

  def get_food
    @food = current_user.foods.find_by(uuid: params[:uuid])
  end
end
