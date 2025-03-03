class Api::V1::CategoriesController < ApplicationController
  before_action :authorize_access_request!

  def index
    render json: Category.all, status: :ok
  end
end