module Milestones
  class RecommendationService < ApplicationService
    MAX_MILESTONES = 10

    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def call
      fetch_recommended_milestones
    end

    private

    def fetch_recommended_milestones
      user_milestone_ids = user.milestones.pluck(:id)

      # Get category frequency for this user's milestones
      category_counts = user.milestones
                            .joins(:milestone_categories)
                            .group('milestone_categories.category_id')
                            .count

      # Get milestone recommendations based on category weights
      recommendations = Milestone
        .joins(:milestone_categories)
        .where.not(id: user_milestone_ids)
        .where(milestone_categories: { category_id: category_counts.keys })
        .accesible_by_user(user)
        .select('milestones.*, milestone_categories.category_id')
        .distinct

      # Sort and score milestones by user interest in the category
      scored = recommendations.each_with_object({}) do |milestone, hash|
        hash[milestone] ||= 0
        hash[milestone] += category_counts[milestone.milestone_categories.first.category_id] || 0
      end

      # Pick top scored milestones
      top_recommendations = scored.sort_by { |_, score| -score }
                                  .first(MAX_MILESTONES)
                                  .map(&:first)

      # Fallback: add random accessible milestones if needed
      if top_recommendations.size < MAX_MILESTONES
        fillers = Milestone
          .accesible_by_user(user)
          .where.not(id: user_milestone_ids + top_recommendations.map(&:id))
          .limit(MAX_MILESTONES - top_recommendations.size)
        top_recommendations.concat(fillers)
      end

      top_recommendations.map do |milestone|
        {
          id: milestone.id,
          name: milestone.name,
          description: milestone.description,
          image_url: image_url(milestone)
        }
      end
    end

    def image_url(milestone)
      return nil unless milestone.image.attached?
      Rails.application.routes.url_helpers.url_for(milestone.image, host: ENV['HOST_URL'])
    end
  end
end
