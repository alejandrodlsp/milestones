class Api::V1::MilestoneCheckpointsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_milestone

  def create
    checkpoint = @milestone.checkpoints.new(name: params["name"])

    if checkpoint.save
      render json: checkpoint.as_json, status: :created
    else
      render json: { status: "error", errors: checkpoint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    checkpoint = @milestone.checkpoints.find_by(id: params[:id])

    if checkpoint
      checkpoint.destroy
      render json: { status: "ok", message: "Checkpoint deleted successfully" }, status: :ok
    else
      render json: { status: "error", error: "Checkpoint not found" }, status: :not_found
    end
  end

  def update
    checkpoint = @milestone.checkpoints.find_by(id: params[:id])

    completed_param = params[:completed] == false || params[:completed] == "0"
    if params[:completed]
      checkpoint.update(completed_at: Time.current)
    elsif completed_param
      checkpoint.update(completed_at: nil)
    end
    
    render json: { status: "ok", message: "Checkpoint updated", checkpoint: checkpoint }, status: :ok
  end

  private

  def set_milestone
    @milestone = Milestone
      .accesible_by_user(current_user)
      .where(id: params[:milestone_id])
      .first

    head :not_found unless @milestone.user_id == current_user.id
    head :not_found unless @milestone
  end
end
