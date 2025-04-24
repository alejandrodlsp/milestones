
module Milestones
  class DeleteService < ApplicationService
    attr_accessor :milestone, :current_user

    def initialize(milestone, current_user)
      @milestone = milestone
      @current_user = current_user
    end

    def validate!
      unless milestone.user_id == current_user.id
        raise StandardError, "You are not authorized to delete this milestone"
      end
    end

    def call
      milestone.update(status: 2)
    end
  end
end