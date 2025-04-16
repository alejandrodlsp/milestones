module Milestones
  class FilterPaginateService < ApplicationService
    MAX_MILESTONES_PER_PAGE = 18

    def initialize(milestones, current_user, params)
      @milestones = milestones
      @current_user = current_user
      @params = params
    end

    def call
      @milestones = filter_by_name
      @milestones = filter_by_category
      @milestones = @milestones.page(@params[:page]).per(MAX_MILESTONES_PER_PAGE)

      response_data = @milestones.map { |milestone| MilestoneResponse.new(milestone, @current_user) }
      { milestones: response_data, meta: pagination_meta }
    end

    private

    def filter_by_name
      return @milestones unless @params[:search].present?
      @milestones.where("LOWER(name) LIKE ?", "%#{@params[:search].downcase}%")
    end

    def filter_by_category
      return @milestones unless @params[:category].present?
      @milestones.joins(:milestone_categories).where(milestone_categories: { category_id: @params[:category] })
    end

    def pagination_meta
      {
        total_pages: @milestones.total_pages,
        current_page: @milestones.current_page,
        total_count: @milestones.total_count
      }
    end
  end
end