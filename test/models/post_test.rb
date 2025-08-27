require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:one)
  end

    test "should be valid" do
      assert @post.valid?
    end

    test "title should be present" do
      @post.title = "   "
      assert_not @post.valid?
    end

    test "title should not be too long" do
      @post.title = "a" * 71
      assert_not @post.valid?
    end

    test "title should not be too short" do
      @post.title = "a" * 2
      assert_not @post.valid?
    end

    test "description should not be too long" do
      @post.description = "a" * 401
      assert_not @post.valid?
    end
end
