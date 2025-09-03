class LikedPostsController < ApplicationController
  before_action :require_login
  def like_post
    @post = Post.find(params[:id])
    unless current_user.liked_posts.exists?(post: @post)
      liked_post = current_user.liked_posts.create(post: @post)
      unless liked_post.persisted?
        flash[:alert] = "Unable to like the post. Please try again."
      end
    end
    refresh_likes
  end

  def unlike_post
    @post = Post.find(params[:id])
    if current_user.liked_posts.exists?(post: @post)
      current_user.liked_posts.find_by(post: @post)&.destroy
      refresh_likes
    end
  end

  private
    def require_login
      unless current_user
        redirect_to new_session_path
      end
    end

    def refresh_likes
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "post-#{@post.id}-likes",
              partial: "posts/post_likes",
              locals: { post: @post }
            )
          ]
        end
      end
    end
end
