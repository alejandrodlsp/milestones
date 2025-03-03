class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    begin
      user = User.find_by!(email: params[:email])
    rescue
      render json: { error: 'Invalid email/password combination.' }, status: :unauthorized
      return
    end
    
    user.update!(last_login_attempt: DateTime.now)

    unless user.can_login?
      user.increment_login_attempts!
      render json: { error: "Too many failed logging attempts, try again in #{user.timeout} minutes." }, status: :unauthorized
      return
    end

    unless user.authenticate(params[:password]) 
      user.increment_login_attempts!
      render json: { error: "Invalid email/password combination." }, status: :unauthorized
      return
    end

    user.reset_login_attempts!

    payload  = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    tokens = session.login
    response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:access],
                        httponly: true,
                        secure: Rails.env.production?)

    render json: { csrf: tokens[:csrf] }
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    session.flush_by_access_payload
    render json: :ok
  end
end