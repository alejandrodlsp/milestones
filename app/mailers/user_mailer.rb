class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Milestones')
  end

  def password_reset_email(user, reset_password_url)
    @user = user
    @reset_password_url = reset_password_url
    mail(to: @user.email, subject: 'Milestones: Your password reset')
  end

  def password_reset_confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Your password has been reset')
  end
end