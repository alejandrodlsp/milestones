class Api::V1::UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: %i[ show update ]

  def me
    render json: UserResponse.new(current_user).as_json
  end

  def show
    render json: UserResponse.new(@user).as_json
  end

  def update
    unless current_user == @user
      return render json: { error: "You are not authorized to update this profile" }, status: :forbidden
    end

    if @user.update(user_params)
      render json: UserResponse.new(@user).as_json
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_password
    user = current_user

    return render json: { error: "New password cannot be blank" }, status: :bad_request if params[:password].blank?
    return render json: { error: "Passwords do not match" }, status: :unprocessable_entity if params[:password] != params[:password_confirmation]

    if user.update(password: params[:password])
      render json: { status: "ok", message: "Password updated successfully" }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :last_name, :image)
  end

  def set_user
    @user = User.find(params[:id])
    return head :not_found unless @user
  end
end
