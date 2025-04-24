class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization

  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  private

  def current_user
    @current_user ||= User.find(payload["user_id"])
  end

  def not_authorized
    render_error("Unauthorized", :unauthorized)
  end

  def render_error(message, status = :unprocessable_entity, details: nil)
    error_response = { error: message }
    error_response[:details] = details if details.present?
    render json: error_response, status: status
  end
end
