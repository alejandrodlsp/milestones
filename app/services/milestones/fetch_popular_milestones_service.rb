module Milestones
  class FetchPopularMilestonesService < ApplicationService
    include Rails.application.routes.url_helpers

    CACHE_KEY = "popular_milestones"
    CACHE_EXPIRATION = 1.hour
    MAX_MILESTONES = 10

    def call
      Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_EXPIRATION) do
        fetch_popular_milestones
      end
    end

    private

    def fetch_popular_milestones
      # Agrupa por original_milestone_id y cuenta la cantidad de clones
      grouped = Milestone
        .where.not(original_milestone_id: nil)
        .group(:original_milestone_id)
        .order(Arel.sql('COUNT(*) DESC'))
        .limit(MAX_MILESTONES)
        .count
    
      # Devuelve un hash: { original_milestone_id => count }
      original_ids = grouped.keys
      counts = grouped
    
      # Trae las milestones originales correspondientes
      popular_originals = Milestone
        .where(id: original_ids)
        .index_by(&:id)
    
      # Completa si hay menos de MAX_MILESTONES
      if popular_originals.size < MAX_MILESTONES
        filler = Milestone
          .where(user_id: nil, original_milestone_id: nil)
          .where.not(id: original_ids)
          .limit(MAX_MILESTONES - popular_originals.size)
    
        filler.each do |m|
          popular_originals[m.id] = m
          counts[m.id] = 0
        end
      end
    
      # Arma la lista final de 15
      popular_originals.values.map do |milestone|
        {
          id: milestone.id,
          name: milestone.name,
          description: milestone.description,
          count: counts[milestone.id] || 0,
          image_url: image_url(milestone)
        }
      end
    end
    
    
    def image_url(milestone)
      return nil unless milestone.image.attached?
      url_for(milestone.image)
    end
  end
end