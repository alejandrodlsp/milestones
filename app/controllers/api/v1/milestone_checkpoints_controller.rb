class Api::V1::MilestoneCheckpointsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_milestone

  def create
    checkpoint = @milestone.checkpoints.new(name: params["name"])

    if checkpoint.save
      render json: checkpoint.as_json, status: :created
    else
      render json: { errors: checkpoint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    checkpoint = @milestone.checkpoints.find_by(id: params[:id])
    return head :not_found unless @milestone.user_id == current_user.id

    if checkpoint
      checkpoint.destroy
      render json: { status: 'ok', message: 'Checkpoint deleted successfully' }, status: :ok
    else
      render json: { error: 'Checkpoint not found' }, status: :not_found
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
end
