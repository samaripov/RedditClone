class LikedPostsController < ApplicationController
  def like_post
    @post = Post.find(params[:id])
    unless current_user.liked_posts.exists?(post: @post)
      liked_post = current_user.liked_posts.create(post: @post)
      refresh_likes
      unless liked_post.persisted?
        flash[:alert] = "Unable to like the post. Please try again."
      end
    end
  end

  def unlike_post
    @post = Post.find(params[:id])
    if current_user.liked_posts.exists?(post: @post)
      current_user.liked_posts.find_by(post: @post)&.destroy
      refresh_likes
    end
  end

  private
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
