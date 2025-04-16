require "test_helper"

class MilestoneCompletionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @milestone_completion = milestone_completions(:one)
  end

  test "should get index" do
    get milestone_completions_url, as: :json
    assert_response :success
  end

  test "should create milestone_completion" do
    assert_difference("MilestoneCompletion.count") do
      post milestone_completions_url, params: { milestone_completion: { milestone_id: @milestone_completion.milestone_id, summary: @milestone_completion.summary } }, as: :json
    end

    assert_response :created
  end

  test "should show milestone_completion" do
    get milestone_completion_url(@milestone_completion), as: :json
    assert_response :success
  end

  test "should update milestone_completion" do
    patch milestone_completion_url(@milestone_completion), params: { milestone_completion: { milestone_id: @milestone_completion.milestone_id, summary: @milestone_completion.summary } }, as: :json
    assert_response :success
  end

  test "should destroy milestone_completion" do
    assert_difference("MilestoneCompletion.count", -1) do
      delete milestone_completion_url(@milestone_completion), as: :json
    end

    assert_response :no_content
  end
end
