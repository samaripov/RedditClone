require "test_helper"

class FollowingsControllerTest < ActionDispatch::IntegrationTest
  test "should get follow" do
    get followings_follow_url
    assert_response :success
  end

  test "should get unfollow" do
    get followings_unfollow_url
    assert_response :success
  end
end
