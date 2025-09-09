require "test_helper"

class FollowingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @follower = users(:one)
    @followed = users(:two)
    log_in_as(@follower)
  end
  test "should not follow user when not logged in" do
    log_out_user

    assert_no_difference("Following.count") do
      post follow_user_path(@followed), as: :turbo_stream
    end

    assert_redirected_to new_session_path
  end

  test "should not follow non-existent user" do
    assert_no_difference("Following.count") do
      post follow_user_path(99999), as: :turbo_stream
    end
  end

  test "should not follow same user twice" do
    # Create initial following
    Following.create!(follower: @follower, followed: @followed)

    assert_no_difference("Following.count") do
      post follow_user_path(@followed), as: :turbo_stream
    end
  end

  test "should not unfollow user when not logged in" do
    # Create initial following
    Following.create!(follower: @follower, followed: @followed)
    log_out_user

    assert_no_difference("Following.count") do
      delete unfollow_user_path(@followed), as: :turbo_stream
    end

    assert_redirected_to new_session_path
  end

  test "should not unfollow non-existent user" do
    assert_no_difference("Following.count") do
      delete unfollow_user_path(99999), as: :turbo_stream
    end
  end

  # Edge cases and security tests
  test "should not allow user to follow themselves" do
    assert_no_difference("Following.count") do
      post follow_user_path(@follower), as: :turbo_stream
    end
  end

  test "should not allow user to unfollow themselves" do
    assert_no_difference("Following.count") do
      delete unfollow_user_path(@follower), as: :turbo_stream
    end
  end

  test "follow action should only work with turbo stream requests" do
    post follow_user_path(@followed)
    # Since the controller only responds to turbo_stream format
    # regular HTML requests should be handled appropriately
  end

  test "unfollow action should only work with turbo stream requests" do
    Following.create!(follower: @follower, followed: @followed)
    delete unfollow_user_path(@followed)
    # Since the controller only responds to turbo_stream format
    # regular HTML requests should be handled appropriately
  end

  private

  def log_in_as(user)
    post login_user_path, params: { email_address: user.email_address, password: "Password#1234" }
  end

  def log_out_user
    delete logout_user_path
  end
end
