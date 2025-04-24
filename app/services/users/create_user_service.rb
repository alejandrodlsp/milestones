module Users
  class CreateUserService < ApplicationService
    attr_accessor :user_params
    
    def initialize(user_params)
      @user_params = user_params
    end

    def call
      user = User.new(
        user_params.merge(last_login_attempt: DateTime.now)
      )

      unless user.save
        raise StandardError, { error: user.errors.full_messages.join(" ") }
      end

      #UserMailer.welcome_email(user).deliver_later
      list = List.create(
        name: "Epic Quests of My Lifetime", 
        description: "A bold and personal collection of dreams, challenges, and milestones I aim to conquer before the final credits roll.",
        user: user
      )

      user
    end
  end
end