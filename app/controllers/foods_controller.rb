class FoodsController < ApplicationController
  require 'google/cloud/translate'

  def index
    project_id = Rails.application.credentials.google[:CLOUD_PROJECT_ID]

    translate = Google::Cloud::Translate.new version: :v2, project_id: project_id

    @text = %w[[オートミール 20g] [卵 3個]]

    target = 'en'

    @translation = translate.translate(@text, to: target)

    @foods = Food.all.includes(:user, :tags).order(created_at: :desc)
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
