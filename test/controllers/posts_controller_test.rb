require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_params = { username: "newuser1234", email_address: "newuser1243@example.com", password: "Password#1234", password_confirmation: "Password#1234" }
    post users_path, params: { user: @user_params }
    @user = User.last
    @post = posts(:one)
    @post.user = @user
    @post.save
  end

  test "should get index" do
    log_in_as(@user)
    get home_path
    assert_redirected_to posts_path(1)
  end

  test "should get new when logged in" do
    get new_user_post_path(@user), as: :turbo_stream
    assert_response :success
  end

  test "should not get new when not logged in" do
    get new_user_post_path(@user)
    assert_response :success
  end

  test "should create post when logged in" do
    assert_difference("Post.count") do
      post user_posts_path(@user), params: { post: { title: 'New Post', description: 'A new post' } }
    end
  end

  test "should not create post when not logged in" do
    log_out_user
    assert_no_difference("Post.count") do
      post user_posts_path(@user), params: { post: { title: 'New Post', description: 'A new post' } }
    end
  end

  test "should not create post with invalid parameters" do
    assert_no_difference("Post.count") do
      post user_posts_path(@user), params: { post: { title: "", description: "" } }
    end

    assert_response :not_acceptable
  end
end
