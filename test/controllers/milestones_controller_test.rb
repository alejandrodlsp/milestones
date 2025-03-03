require "test_helper"

class MilestonesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @milestone = milestones(:one)
  end

  test "should get index" do
    get milestones_url, as: :json
    assert_response :success
  end

  test "should create milestone" do
    assert_difference("Milestone.count") do
      post milestones_url, params: { milestone: { description: @milestone.description, title: @milestone.title, users_id: @milestone.users_id } }, as: :json
    end

    assert_response :created
  end

  test "should show milestone" do
    get milestone_url(@milestone), as: :json
    assert_response :success
  end

  test "should update milestone" do
    patch milestone_url(@milestone), params: { milestone: { description: @milestone.description, title: @milestone.title, users_id: @milestone.users_id } }, as: :json
    assert_response :success
  end

  test "should destroy milestone" do
    assert_difference("Milestone.count", -1) do
      delete milestone_url(@milestone), as: :json
    end

    assert_response :no_content
  end
end
