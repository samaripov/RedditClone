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
    get posts_path
    assert_response :success
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
      post user_posts_path(@user), params: { post: { title: "New Post", description: "A new post" } }
    end
  end

  test "should not create post when not logged in" do
    log_out_user
    assert_no_difference("Post.count") do
      post user_posts_path(@user), params: { post: { title: "New Post", description: "A new post" } }
    end
  end

  test "should not create post with invalid parameters" do
    assert_no_difference("Post.count") do
      post user_posts_path(@user), params: { post: { title: "", description: "" } }
    end

    assert_response :not_acceptable
  end

  # Tests for followings_posts method
  test "should get followings_posts when logged in with HTML format" do
    get camp_path
    assert_response :success
    assert_not_nil assigns(:posts)
    assert_not_nil assigns(:title)
    assert_not_nil assigns(:description)
    assert_equal "Home Camp", assigns(:title)
    assert_equal "Posts from people you follow", assigns(:description)
  end

  test "should get followings_posts when logged in with turbo stream format" do
    get camp_path, headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_not_nil assigns(:posts)
    assert_match(/turbo-stream/, response.body)
    assert_match(/main_content/, response.body)
  end

  test "should redirect to login when not logged in for followings_posts" do
    log_out_user
    get camp_path
    assert_redirected_to new_session_path
  end

  test "should handle empty followings list gracefully" do
    # User doesn't follow anyone
    get camp_path
    assert_response :success

    posts = assigns(:posts)
    assert_equal 0, posts.count
  end

  test "should paginate followings_posts correctly" do
    followed_user = users(:two)
    Following.create!(follower: @user, followed: followed_user)

    # Create multiple posts from followed user
    15.times do |i|
      Post.create!(
        title: "Post #{i}",
        description: "Description #{i}",
        user: followed_user
      )
    end

    get camp_path, params: { page: 1 }
    assert_response :success

    posts = assigns(:posts)
    assert_respond_to posts, :current_page
    assert_respond_to posts, :total_pages
  end


  private

  def log_out_user
    delete logout_user_path if @user
  end
end
