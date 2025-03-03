class PasswordsController < ApplicationController
  def forgot
    return render json: {error: 'Email not present'} if params[:email].blank?
    return render json: {error: 'URL not present'} if params[:reset_url].blank?

    user = User.find_by_email(params[:email])

    return render json: {error: ['Email not found in our system. Check that it is correct and try again.']}, status: :not_found unless user.present?

    user.generate_password_token!

    reset_link = "#{params['reset_url']}?token=#{user.reset_password_token}&email=#{user.email}"
    UserMailer.password_reset_email(user, reset_link).deliver_later

    render json: {status: 'ok'}, status: :ok
  end

  def reset
    return render json: {error: 'Email not present'} if params[:email].blank?
    return render json: {error: 'Reset token not found'} if params[:token].blank?

    user = User.find_by(email: params[:email], reset_password_token: params[:token])

    unless user.present?
      return render json: {error:  ['User / Token not found, try again.']}, status: :not_found
    end
    
    unless user.password_token_valid?
      return render json: {error:  ['Invalid link, try again.']}, status: :not_found
    end

    UserMailer.password_reset_confirmation_email(user).deliver_later

    if user.reset_password!(params[:password])
      return render json: {status: 'ok'}, status: :ok
    end
    
    render json: {error: user.errors.full_messages}, status: :unprocessable_entity
  end
end