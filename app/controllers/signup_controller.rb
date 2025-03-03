class SignupController < ApplicationController
  def create
    user = User.new(user_params.merge(last_login_attempt: DateTime.now))

    unless user.save
      render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
      return
    end

    UserMailer.welcome_email(user).deliver_later

    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    tokens = session.login

    response.set_cookie(JWTSessions.access_cookie,
      value: tokens[:access],
      httponly: true,
      secure: Rails.env.production?
    )
    render json: { csrf: tokens[:csrf] }
  end

  private

  def user_params
    params.permit(:email, :name, :last_name, :password, :password_confirmation)
  end
end