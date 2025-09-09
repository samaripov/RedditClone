require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      username: "testuser",
      email_address: "test@example.com",
      password: "Password#1234",
      password_confirmation: "Password#1234"
    )
  end

  # Validation tests
  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should require email address" do
    @user.email_address = nil
    assert_not @user.valid?
    assert_includes @user.errors[:email_address], "can't be blank"
  end

  test "should require unique email address" do
    @user.save!
    duplicate_user = @user.dup
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email_address], "has already been taken"
  end

  test "should normalize email address" do
    @user.email_address = "  TEST@EXAMPLE.COM  "
    @user.save!
    assert_equal "test@example.com", @user.email_address
  end

  test "should validate email format" do
    invalid_emails = ["invalid", "@example.com", "test@", "test.example.com"]
    invalid_emails.each do |email|
      @user.email_address = email
      assert_not @user.valid?, "#{email} should be invalid"
      assert_includes @user.errors[:email_address], "is invalid"
    end
  end

  test "should require password" do
    @user.password = nil
    @user.password_confirmation = nil
    assert_not @user.valid?
    assert_includes @user.errors[:password], "can't be blank"
  end

  test "should require password confirmation" do
    @user.password_confirmation = "different"
    assert_not @user.valid?
    assert_includes @user.errors[:password_confirmation], "doesn't match Password"
  end

  test "should validate password length" do
    @user.password = @user.password_confirmation = "short"
    assert_not @user.valid?
    assert_includes @user.errors[:password], "is too short (minimum is 8 characters)"

    @user.password = @user.password_confirmation = "a" * 71
    assert_not @user.valid?
    assert_includes @user.errors[:password], "is too long (maximum is 70 characters)"
  end

  test "should validate password complexity" do
    # Missing uppercase
    @user.password = @user.password_confirmation = "password#1234"
    assert_not @user.valid?
    assert_includes @user.errors[:password], "Must contain at least one uppercase letter"

    # Missing lowercase
    @user.password = @user.password_confirmation = "PASSWORD#1234"
    assert_not @user.valid?
    assert_includes @user.errors[:password], "Must contain at least one lowercase letter"

    # Missing digit
    @user.password = @user.password_confirmation = "Password#"
    assert_not @user.valid?
    assert_includes @user.errors[:password], "Must contain at least one digit"

    # Missing special character
    @user.password = @user.password_confirmation = "Password1234"
    assert_not @user.valid?
    assert_includes @user.errors[:password], "Must contain at least one special character"
  end

  # Association tests
  test "should have many posts" do
    assert_respond_to @user, :posts
  end

  test "should have many liked_posts" do
    assert_respond_to @user, :liked_posts
  end

  test "should have many favourite_posts through liked_posts" do
    assert_respond_to @user, :favourite_posts
  end

  test "should have many comments" do
    assert_respond_to @user, :comments
  end

  test "should have many followings" do
    assert_respond_to @user, :followings
  end

  test "should have many followed_users through followings" do
    assert_respond_to @user, :followed_users
  end

  test "should have many reverse_followings" do
    assert_respond_to @user, :reverse_followings
  end

  test "should have many followers through reverse_followings" do
    assert_respond_to @user, :followers
  end

  test "should have many sessions" do
    assert_respond_to @user, :sessions
  end

  test "should destroy associated sessions when user is destroyed" do
    @user.save!
    @user.sessions.create!
    assert_difference "Session.count", -1 do
      @user.destroy!
    end
  end

  # Avatar attachment tests
  test "should have avatar attachment" do
    assert_respond_to @user, :avatar
  end
  # Functional tests
  test "should authenticate with correct password" do
    @user.save!
    assert @user.authenticate("Password#1234")
    assert_not @user.authenticate("wrongpassword")
  end

  test "should create following relationships correctly" do
    @user.save!
    other_user = users(:two)
    
    # Follow another user
    following = @user.followings.create!(followed: other_user)
    
    assert_includes @user.followed_users, other_user
    assert_includes other_user.followers, @user
  end

  test "should create liked posts correctly" do
    @user.save!
    post = posts(:one)
    
    # Like a post
    liked_post = @user.liked_posts.create!(post: post)
    
    assert_includes @user.favourite_posts, post
    assert_includes post.likes_from_users, @user
  end
end
