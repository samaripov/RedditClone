module PostsHelper
  def current_user_liked?(post)
    if authenticated?
      current_user.liked_posts.exists?(post: post)
    end
  end
end
