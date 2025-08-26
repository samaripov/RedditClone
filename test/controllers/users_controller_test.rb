require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def log_in_as(user, password: "password123")
    post login_user_path, params: { session: { email_address: user.email_address, password: user.password } }
  end

  setup do
    @user_params = { username: "newuser1234", email_address: "newuser1243@example.com", password: "password123", password_confirmation: "password123" }
    post users_path, params: { user: @user_params }
    @user = User.last
  end
  test "should get new" do
    get new_user_path
    assert_response :success
  end
  test "should create user" do
    new_user_params = { username: "newuser123", email_address: "newuser123@example.com", password: "password123", password_confirmation: "password123" }
    assert_difference("User.count", 1) do
      post users_path, params: { user: new_user_params }
    end
    assert_redirected_to root_path
  end
  test "should get edit" do
    get edit_user_path(@user)
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
