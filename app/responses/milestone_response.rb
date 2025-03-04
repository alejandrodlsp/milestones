class MilestoneResponse
  include Rails.application.routes.url_helpers

  def initialize(milestone, includes: [])
    @milestone = milestone
    @includes = includes
  end

  def as_json
    data = {
      id: @milestone.id,
      name: @milestone.name,
      description: @milestone.description,
      due_date: @milestone.due_date,
      private: @milestone.private,
      image_url: image_url,
      categories: @milestone.categories.pluck(:name)
    }

    data[:user] = UserResponse.new(@milestone.user).as_json if @includes.include?(:user) && @milestone.user
    data[:comments] = comments if @includes.include?(:comments)
    data[:lists] = lists if @includes.include?(:lists)
    data[:checkpoints] = checkpoints if @includes.include?(:checkpoints)

    data
  end

  private

  def checkpoints
    @_checkpoints ||= @milestone.checkpoints
  end

  def lists
    @_lists ||= @milestone.lists.map { |list| format_list(list) }
  end

  def comments
    @_comments ||= @milestone.comments.map { |comment| format_comment(comment) }
  end

  def format_list(list)
    {
      id: list.id,
      name: list.name
    }
  end

  def format_comment(comment)
    MilestoneCommentResponse.new(comment).as_json
  end

  def image_url
    return nil unless @milestone.image.attached?
    url_for(@milestone.image)
  end
end
