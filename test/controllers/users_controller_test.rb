require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_path
    assert_response :success
  end

  setup do
    @user = users(:one)
  end

  test "should create user" do
    new_user_params = { username: "newuser123", email_address: "newuser123@example.com", password: "password123" }
    assert_difference("User.count", 1) do
      post users_path, params: { user: new_user_params }
    end
    assert_redirected_to User.last
  end

  test "should get edit" do
    get users_edit_url
    assert_response :success
  end

  test "should get update" do
    get users_update_url
    assert_response :success
  end

  test "should get destroy" do
    get users_destroy_url
    assert_response :success
  end
end
