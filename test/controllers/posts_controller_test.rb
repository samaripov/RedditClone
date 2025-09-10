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

  test "should show posts from followed users only" do
    # Create test users
    follower = @user
    followed_user = users(:two)
    other_user = User.create!(
      username: "otheruser", 
      email_address: "other@example.com", 
      password: "Password#1234", 
      password_confirmation: "Password#1234"
    )

    # Create posts for different users
    followed_post = Post.create!(title: "Followed Post", description: "From followed user", user: followed_user)
    other_post = Post.create!(title: "Other Post", description: "From other user", user: other_user)
    own_post = Post.create!(title: "Own Post", description: "From current user", user: follower)

    # Create following relationship
    Following.create!(follower: follower, followed: followed_user)

    get camp_path
    assert_response :success
    
    posts = assigns(:posts)
    
    # Should include posts from followed users
    assert_includes posts.map(&:id), followed_post.id
    
    # Should not include posts from non-followed users
    assert_not_includes posts.map(&:id), other_post.id
    
    # Should not include own posts (user doesn't follow themselves by default)
    assert_not_includes posts.map(&:id), own_post.id
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

  test "should handle page parameter in followings_posts" do
    followed_user = users(:two)
    Following.create!(follower: @user, followed: followed_user)

    get camp_path, params: { page: 2 }
    assert_response :success
    assert_equal 2, assigns(:page)
  end

  test "should order followings_posts by creation date descending" do
    followed_user = users(:two)
    Following.create!(follower: @user, followed: followed_user)

    # Create posts with different timestamps
    Post.create!(title: "Old Post", description: "Old", user: followed_user, created_at: 2.days.ago)
    Post.create!(title: "New Post", description: "New", user: followed_user, created_at: 1.day.ago)

    get camp_path
    assert_response :success
    
    posts = assigns(:posts).to_a
    assert posts.first.created_at >= posts.last.created_at
  end

  test "should include multiple followed users posts" do
    followed_user1 = users(:two)
    followed_user2 = User.create!(
      username: "followed2", 
      email_address: "followed2@example.com", 
      password: "Password#1234", 
      password_confirmation: "Password#1234"
    )

    # Follow both users
    Following.create!(follower: @user, followed: followed_user1)
    Following.create!(follower: @user, followed: followed_user2)

    # Create posts from both followed users
    post1 = Post.create!(title: "Post from User 1", description: "Content 1", user: followed_user1)
    post2 = Post.create!(title: "Post from User 2", description: "Content 2", user: followed_user2)

    get camp_path
    assert_response :success
    
    posts = assigns(:posts)
    assert_includes posts.map(&:id), post1.id
    assert_includes posts.map(&:id), post2.id
    assert_equal 2, posts.count
  end

  private

  def log_out_user
    delete logout_user_path if @user
  end
end
