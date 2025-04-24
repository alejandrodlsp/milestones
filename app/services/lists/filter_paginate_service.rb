module Lists
  class FilterPaginateService < ApplicationService
    MAX_LISTS_PER_PAGE = 18

    def initialize(lists, current_user, params)
      @lists = lists
      @current_user = current_user
      @params = params
    end

    def call
      @lists = filter_by_name
      @lists = @lists.page(@params[:page]).per(MAX_LISTS_PER_PAGE)

      response_data = @lists.map { |list| ListResponse.new(list, @current_user) }
      { lists: response_data, meta: pagination_meta }
    end

    private

    def filter_by_name
      return @lists unless @params[:search].present?
      @lists.where("LOWER(name) LIKE ?", "%#{@params[:search].downcase}%")
    end

    def pagination_meta
      {
        total_pages: @lists.total_pages,
        current_page: @lists.current_page,
        total_count: @lists.total_count
      }
    end
  end
end