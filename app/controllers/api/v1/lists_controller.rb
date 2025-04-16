class Api::V1::ListsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_list, only: %i[ show update destroy add_milestone ]

  def index
    render json: current_user.lists, status: :ok
  end

  def show
    includes = params[:includes]&.split(",")&.map(&:to_sym) || []

    render json: ListResponse.new(@list, current_user, includes: includes).as_json
  end

  def create
    @list = List.new(list_params)
    @list.update({ user_id: current_user.id })

    if @list.save
      render json: @list, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def update
    includes = params[:includes]&.split(",")&.map(&:to_sym) || []

    if @list.update(list_params)
      render json: ListResponse.new(@list, current_user, includes: includes).as_json
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def add_milestone
    @milestone = Milestone.find(params[:milestone_id])
    render json: { "message": "No milestone found" }, status: :unprocessable_entity unless @milestone
    render json: { "message": "No list found" }, status: :unprocessable_entity unless @list

    if @milestone.user != current_user
      @milestone = Milestones::CloneMilestoneService.call(@milestone, current_user)
    end

    MilestoneList.create(milestone: @milestone, list: @list)
    render json: @milestone, status: :created
  end

  def destroy
    @list.destroy!
  end

  private
    def set_list
      @list = current_user.lists.find(params.expect(:id))
    end

    def list_params
      params.expect(list: [ :name, :description ])
    end
end
