
module Milestones
  class CompleteService < ApplicationService
    def initialize(params, current_user)
      @milestone_id = params[:milestone_id]
      @summary = params[:summary]
      @images = params[:images]
      @current_user = current_user
    end

    def validate!
      raise ServiceError, "Milestone not found" unless milestone
      raise ServiceError, "Milestone does not belong to user" if milestone.user != @current_user
      raise ServiceError, "Milestone already completed" if milestone.status != 0
    end

    def call
      @milestone_completion = MilestoneCompletion.create(milestone: milestone, summary: @summary, images: @images)
      milestone.update(status: Milestone::COMPLETED)

      @milestone_completion
    end

    private

    def milestone
      @milestone ||= Milestone.find(@milestone_id)
    end
  end
end