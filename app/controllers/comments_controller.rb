class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to food_path(@comment.food.uuid), success: t('.success')
    else
      redirect_to food_path(@comment.food.uuid), danger: t('.fail')
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    redirect_to food_path(@comment.food.uuid), success: t('.success')
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(food_id: Food.find_by(uuid: params[:food_uuid]).id)
  end
end
