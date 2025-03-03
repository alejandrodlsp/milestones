class Api::V1::MilestoneCommentsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_milestone

  def create
    comment = @milestone.comments.new(comment_params)
    comment.user = current_user

    if comment.save
      render json: MilestoneCommentResponse.new(comment).as_json, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    comment = @milestone.comments.find_by(id: params[:id])
    return head :not_found unless @milestone.user_id == current_user.id

    if comment
      comment.destroy
      render json: { status: 'ok', message: 'Comment deleted successfully' }, status: :ok
    else
      render json: { error: 'Comment not found' }, status: :not_found
    end
  end

  private

  def set_milestone
    @milestone = Milestone
      .accesible_by_user(current_user)
      .where(id: params[:milestone_id])
      .first

    return head :not_found unless @milestone
  end

  def comment_params
    params.require(:comment).permit(:message)
  end
end
