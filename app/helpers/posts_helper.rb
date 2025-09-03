module PostsHelper
  def current_user_liked?(post)
    if authenticated? and not current_user.nil?
      current_user.liked_posts.exists?(post: post)
    end
  end
end
