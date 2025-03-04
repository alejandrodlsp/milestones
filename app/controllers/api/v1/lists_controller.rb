class Api::V1::ListsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_list, only: %i[ show update destroy ]

  def index
    render json: current_user.lists, status: :ok
  end

  def show
    render json: @list
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
    if @list.update(list_params)
      render json: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
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
