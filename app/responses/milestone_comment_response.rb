class MilestoneCommentResponse
  def initialize(milestone_comment, includes: [])
    @milestone_comment = milestone_comment
    @includes = includes
  end

  def as_json
    {
      id: @milestone_comment.id,
      message: @milestone_comment.message,
      created_at: @milestone_comment.created_at,
      user: UserResponse.new(@milestone_comment.user).as_json
    }
  end
end
