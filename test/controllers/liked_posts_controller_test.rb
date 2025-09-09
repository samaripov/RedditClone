require "test_helper"

class LikedPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = log_in_as(users(:one))
    @other_user = log_in_as(users(:two))
    @post = posts(:one)
    @other_post = posts(:two)
  end
  test "should redirect to login when user is not logged in for like_post" do
    post like_post_path(@post)

    assert_redirected_to new_session_path
  end

  test "should redirect to login when user is not logged in for unlike_post" do
    delete unlike_post_path(@post)

    assert_redirected_to new_session_path
  end

  test "should only affect current user's likes" do
    log_in_as(@user)
    other_user_like = LikedPost.create!(user: @other_user, post: @other_post)

    # User likes the post
    post like_post_path(@other_post), headers: { "Accept" => "text/vnd.turbo-stream.html" }

    # Other user's like should still exist
    assert LikedPost.exists?(id: other_user_like.id)
    assert LikedPost.exists?(user: @user, post: @other_post)
    assert_equal 2, @other_post.liked_posts.count
  end
end
