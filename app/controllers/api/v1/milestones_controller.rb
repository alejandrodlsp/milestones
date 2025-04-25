class Api::V1::MilestonesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_milestone, only: %i[ show update destroy clone ]

  def index
    milestones = Milestone.public_only

    response = Milestones::FilterPaginateService.call(milestones, current_user, params)

    render json: response
  end

  def show
    includes = params[:includes]&.split(",")&.map(&:to_sym) || []
    
    unless @milestone
      render json: {
        error: "The milestone you are trying to access does not exist anymore or you do not have permissions to view it"
      }, status: :unprocessable_entity
    end
    render json: MilestoneResponse.new(@milestone, current_user, includes: includes).as_json
  end

  def create
    @milestone = if current_user.admin?
      Milestone.new(milestone_params) 
    else
      Milestone.new(milestone_params.merge(user_id: current_user.id))
    end

    if @milestone.save
      render json: @milestone, status: :created
    else
      render json: @milestone.errors, status: :unprocessable_entity
    end
  end

  def update
    unless @milestone.user_id == current_user.id
      render json: { error: "You are not authorized to edit this milestone" }, status: :forbidden
      return
    end

    if @milestone.update(milestone_params)
      render json: @milestone
    else
      render json: @milestone.errors, status: :unprocessable_entity
    end
  end

  def destroy
    deleted_milestone = Milestones::DeleteService.call(@milestone, current_user)
    render json: deleted_milestone, status: :ok
  rescue StandardError => e
    render json: e, status: :unprocessable_entity
  end

  def clone
    cloned_milestone = Milestones::CloneMilestoneService.call(@milestone, current_user)
    render json: cloned_milestone, status: :created
  end

  def from_friends
    @milestones = Milestones::FetchFromFriendsService.call(current_user)

    render json: { milestones: @milestones }, status: :ok
  end

  def from_user
    @milestones = current_user.milestones

    render json: { milestones: @milestones }, status: :ok
  end

  def recommendations
    @milestones = Milestones::RecommendationService.call(current_user)

    render json: { milestones: @milestones }, status: :ok
  end

  def popular
    popular_milestone = Milestones::FetchPopularMilestonesService.call
    render json: popular_milestone, status: :ok
  end

  private

  def set_milestone
    @milestone = Milestone
      .accesible_by_user(current_user)
      .where(id: params[:id])
      .first
  end

  def milestone_params
    params.require(:milestone).permit(:name, :description, :image, :private, :due_date, category_ids: [], list_ids: [], checkpoints_attributes: [:name])
  end
end
