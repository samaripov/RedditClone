ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def log_in_as(user)
      @user_params = { username: user.username, email_address: user.email_address, password: "Password#1234", password_confirmation: "Password#1234" }
      post users_path, params: { user: @user_params }
      User.last
    end

    def log_out_user
      delete logout_user_path
    end
  end
end
