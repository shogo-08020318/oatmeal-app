class FavoritesController < ApplicationController
  def create
    @food = Food.find_by(uuid: params[:uuid])
    current_user.favorite(@food)
  end

  def destroy
    @food = current_user.favorites.find(params[:id]).food
    current_user.unfavorite(@food)
  end
end
