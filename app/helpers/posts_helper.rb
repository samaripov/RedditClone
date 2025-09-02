module PostsHelper
  def current_user_liked?(post)
    current_user.liked_posts.exists?(post: post)
  end
end
