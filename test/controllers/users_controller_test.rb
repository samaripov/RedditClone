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
    new_user_params = { username: "newuser123", email_address: "newuser123@example.com", password: "Password#1234", password_confirmation: "Password#1234" }
    assert_difference("User.count", 1) do
      post users_path, params: { user: new_user_params }
    end
    assert_redirected_to root_path
  end
  test "should get edit" do
    get edit_user_path(@user)
    assert_response :success
  end

  test "should update user with correct current password" do
    patch user_path(@user), params: {
      user: {
        username: "updateduser",
        email_address: "updated@example.com",
        password: "newPassword#1234",
        password_confirmation: "newPassword#1234",
        current_password: "Password#1234"
      }
    }
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal "updateduser", @user.username
    assert_equal "updated@example.com", @user.email_address
  end

  test "should not update user with incorrect current password" do
    patch user_path(@user), params: {
      user: {
        username: "updateduser",
        email_address: "updated@example.com",
        password: "newPassword#1234",
        password_confirmation: "newPassword#1234",
        current_password: "wrongpassword"
      }
    }
    assert_response :unprocessable_entity
    @user.reload
    assert_not_equal "updateduser", @user.username
  end

  test "email address should be present" do
    @user_params = { username: "newuser1234", email_address: "", password: "Password#1234", password_confirmation: "Password#1234" }
    assert_difference("User.count", 0) do
      post users_path, params: { user: @user_params }
    end
  end
  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email_address = @user.email_address.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email address should be valid" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp]
    valid_addresses.each do |valid_address|
      @user.email_address = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email address should be invalid" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email_address = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "password should be present on create" do
    new_user = User.new(username: "newuser", email_address: "new@example.com")
    new_user.password = new_user.password_confirmation = ""
    assert_not new_user.valid?
  end

  test "password should match confirmation" do
    @user.password = "new_password"
    @user.password_confirmation = "different_password"
    assert_not @user.valid?
  end

  test "password should be valid with all required characters" do
    @user.password = @user.password_confirmation = "Password#1234!"
    assert @user.valid?
  end

  test "password should be invalid without uppercase" do
    @user.password = @user.password_confirmation = "password#1234!"
    assert_not @user.valid?
  end

  test "password should be invalid without lowercase" do
    @user.password = @user.password_confirmation = "PASSWORD#1234!"
    assert_not @user.valid?
  end

  test "password should be invalid without a digit" do
    @user.password = @user.password_confirmation = "PasswordA_!"
    assert_not @user.valid?
  end
  
  test "password should be invalid without a special character" do
    @user.password = @user.password_confirmation = "Password1234"
    assert_not @user.valid?
  end
  
  test "password should be invalid with less than 8 characters" do
    @user.password = @user.password_confirmation = "A1_a"
    assert_not @user.valid?
  end
end
