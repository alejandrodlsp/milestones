module Milestones
  class CloneMilestoneService < ApplicationService
    def initialize(milestone, user)
      @milestone = milestone
      @user = user
    end

    def call
      cloned_milestone = @milestone.dup
      cloned_milestone.user = @user
      cloned_milestone.original_milestone = @milestone
      cloned_milestone.private = true # User's copy should be private

      # Copy the attached image
      if @milestone.image.attached?
        cloned_milestone.image.attach(
          io: StringIO.new(@milestone.image.download),
          filename: @milestone.image.filename.to_s,
          content_type: @milestone.image.content_type
        )
      end

      cloned_milestone.save!

      # Clone associated checkpoints
      @milestone.checkpoints.each do |checkpoint|
        cloned_milestone.checkpoints.create!(
          name: checkpoint.name,
          completed_at: nil
        )
      end

      # Clone associated categories
      @milestone.categories.each do |category|
        cloned_milestone.milestone_categories.create!(category: category)
      end

      cloned_milestone
    end
  end
end
