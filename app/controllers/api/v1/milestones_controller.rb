class Api::V1::MilestonesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_milestone, only: %i[ show update destroy clone ]

  def index
    milestones = Milestone.public_only

    response = Milestones::FilterPaginateService.call(milestones, current_user, params)

    render json: response
  end

  def user_milestones
    @milestones = current_user.milestones

    render json: @milestones
  end

  def show
    includes = params[:includes]&.split(",")&.map(&:to_sym) || []

    user_milestone = Milestone.where(user: current_user, original_milestone: @milestone).first
    @milestone = user_milestone if user_milestone

    render json: MilestoneResponse.new(@milestone, current_user, includes: includes).as_json
  end

  def create
    @milestone = Milestone.new(milestone_params.merge(user_id: current_user.id))

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
    unless @milestone.user_id == current_user.id
      render json: { error: "You are not authorized to delete this milestone" }, status: :forbidden
      return
    end

    @milestone.destroy!
  end

  def clone
    cloned_milestone = Milestones::CloneMilestoneService.call(@milestone, current_user)
    render json: cloned_milestone, status: :created
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

    head :not_found unless @milestone
  end

  def milestone_params
    params.require(:milestone).permit(:name, :description, :image, :private, :due_date, category_ids: [], list_ids: [])
  end
end
