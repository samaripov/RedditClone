require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_params = { username: "newuser1234", email_address: "newuser1243@example.com", password: "Password#1234", password_confirmation: "Password#1234" }
    post users_path, params: { user: @user_params }
    @user = User.last
  end

  # We'll need a valid post attributes hash for the create test
  def valid_attributes
    { title: "My First Post", description: "This is a valid post description." }
  end

  # And an invalid one to test failure cases
  def invalid_attributes
    { title: "four", description: "This is too short." } # Assuming title length minimum is 5
  end

  test "should get new" do
    get new_user_post_url(@user)
    assert_response :success
  end

  test "should create post with valid parameters" do
    assert_difference("Post.count") do
      post user_posts_url(@user), params: { post: valid_attributes }
    end
    assert_redirected_to root_path
  end

  test "should not create post with invalid parameters" do
    assert_no_difference("Post.count") do
      post user_posts_url(@user), params: { post: invalid_attributes }
    end
    assert_response :unprocessable_entity
    assert_template :new
  end
end
