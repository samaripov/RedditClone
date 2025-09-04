require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_params = { username: "newuser1234", email_address: "newuser1243@example.com", password: "Password#1234", password_confirmation: "Password#1234" }
    post users_path, params: { user: @user_params }
    @user = User.last
  end

  test "should get new" do
    get new_user_path
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_path, params: { user: { username: "newuser", email_address: "newuser@example.com", password: "Password#1234", password_confirmation: "Password#1234" } }
    end

    assert_redirected_to user_path(User.last)
  end

  test "should show user" do
    get user_path(@user)
    assert_response :success
  end

  test "should get edit when logged in" do
    get edit_user_path(@user)
    assert_response :success
  end

  test "should not get edit when not logged in" do
    log_out_user
    get edit_user_path(@user)
    assert_redirected_to new_session_path
  end

  test "should update user when logged in with correct password" do
    patch user_path(@user), params: { user: { username: "updateduser", current_password: "Password#1234" } }
    @user.reload
    assert_equal "updateduser", @user.username
  end

  test "should not update user with incorrect password" do
    patch user_path(@user), params: { user: { username: "updateduser", current_password: "wrongpassword" } }
    assert_response :not_acceptable
  end

  test "should not update user when not logged in" do
    log_out_user
    patch user_path(@user), params: { user: { username: "updateduser" } }
    assert_redirected_to new_session_path
  end

  test "should destroy user when logged in" do
    assert_difference("User.count", -1) do
      delete user_path(@user), params: { user: { current_password: "Password#1234" } }
    end
  end

  test "should not destroy user when not logged in" do
    log_out_user
    assert_no_difference("User.count") do
      delete user_path(@user)
    end

    assert_redirected_to new_session_path
  end
end
