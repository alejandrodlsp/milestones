class SignupController < ApplicationController
  def create
    user = Users::CreateUserService.call(user_params)
    
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    tokens = session.login

    response.set_cookie(JWTSessions.access_cookie,
      value: tokens[:access],
      httponly: true,
      secure: Rails.env.production?
    )
    render json: { csrf: tokens[:csrf] }
  rescue StandardError => e
    render json: { error: e }, status: :unprocessable_entity
  end

  private

  def user_params
    params.permit(:email, :name, :last_name, :password, :password_confirmation)
  end
end
