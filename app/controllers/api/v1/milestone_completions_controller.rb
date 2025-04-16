class Api::V1::MilestoneCompletionsController < ApplicationController
  before_action :authorize_access_request!

  def show
    @milestone_completion = user_milestone_completion.where(milestone_id: params[:id]).first
    render json: MilestoneCompletionResponse.new(@milestone_completion).as_json
  end

  # POST /milestone_completions
  def create
    @milestone_completion = Milestones::CompleteService.call(milestone_completion_params, current_user)

    render json: MilestoneCompletionResponse.new(@milestone_completion).as_json, status: :created
  rescue ApplicationService::ServiceError => e
    render json: { "message": e.message }, status: :unprocessable_entity
  end

  private
    def user_milestone_completion
      MilestoneCompletion.joins(:milestone).where(milestone: { user_id: current_user.id })
    end

    def milestone_completion_params
      params.permit(:milestone_id, :summary, images: [])
    end
end
