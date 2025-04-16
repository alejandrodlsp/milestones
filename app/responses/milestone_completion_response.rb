class MilestoneCompletionResponse
  include Rails.application.routes.url_helpers

  def initialize(milestone_completion)
    @milestone_completion = milestone_completion
  end

  def as_json
    {
      id: @milestone_completion.id,
      summary: @milestone_completion.summary,
      images_url: images_url
    }
  end

  private

  def images_url
    return [] unless @milestone_completion.images.attached?

    @milestone_completion.images.map do |image|
      url_for(image)
    end
  end
end
