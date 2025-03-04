class FetchPopularMilestonesService < ApplicationService
  include Rails.application.routes.url_helpers

  CACHE_KEY = "popular_milestones"
  CACHE_EXPIRATION = 1.second
  MAX_MILESTONES = 10

  def call
    #Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_EXPIRATION) do
      fetch_popular_milestones
    #end
  end

  private

  def fetch_popular_milestones
    # Fetch the popular milestones based on original_milestone_id and count the number of clones for each original milestone
    popular_milestones = Milestone
      .where.not(original_milestone_id: nil)  # Only consider cloned milestones
      .group(:original_milestone_id)  # Group by the original milestone ID
      .select('milestones.original_milestone_id, COUNT(milestones.original_milestone_id) AS count')  # Aggregate count
      .order('count DESC')  # Sort by the count
      .limit(MAX_MILESTONES)  # Limit the results to the top 15 most popular
  
    # If no popular milestones exist (i.e., no clones), fall back to public milestones
    if popular_milestones.empty?
      popular_milestones = Milestone
        .where(original_milestone_id: nil)  # Get external (public) milestones
        .limit(MAX_MILESTONES)  # Limit to 15
    end
  
    # Get the details of the original milestones from the popular milestones
    original_ids = popular_milestones.map { |milestone| milestone[:original_milestone_id] || milestone[:id] }.compact
    milestones = Milestone.where(id: original_ids).index_by(&:id)
    
    # Build the final result by combining the popular milestones with their clone counts
    popular_milestones.map do |milestone|
      milestone_id = milestone[:original_milestone_id] || milestone[:id]
      milestone_instance = milestones[milestone_id]
      {
        id: milestone_instance.id,
        name: milestone_instance.name,
        description: milestone_instance.description,
        count: milestone[:count].to_i,
        image: image_url(milestone_instance)
      }
    end
  end
  
  def image_url(milestone)
    return nil unless milestone.image.attached?
    url_for(milestone.image)
  end
end
