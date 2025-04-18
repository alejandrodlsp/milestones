require "test_helper"

class ListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @list = lists(:one)
  end

  test "should get index" do
    get lists_url, as: :json
    assert_response :success
  end

  test "should create list" do
    assert_difference("List.count") do
      post lists_url, params: { list: { description: @list.description, name: @list.name, user_id: @list.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show list" do
    get list_url(@list), as: :json
    assert_response :success
  end

  test "should update list" do
    patch list_url(@list), params: { list: { description: @list.description, name: @list.name, user_id: @list.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy list" do
    assert_difference("List.count", -1) do
      delete list_url(@list), as: :json
    end

    assert_response :no_content
  end
end
