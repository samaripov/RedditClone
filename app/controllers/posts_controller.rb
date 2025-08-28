class PostsController < ApplicationController
  before_action :set_user, only: %i[ new create ]
  def index
    if current_user.nil?
      redirect_to login_user_path
      return
    end
    @user = current_user
    @global_posts = Post.order(created_at: :desc).page(1).per(10).reverse
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        @user = current_user
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("posts", @post),
            turbo_stream.replace("profile_actions", partial: "users/profile_actions")
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("post_form_container", partial: "posts/form", locals: { post: @post })
          ], status: :unprocessable_entity
        end
      end
    end
  end

  def edit
  end

  private
    def set_user
      @user = current_user
    end
    def post_params
      params.require(:post).permit(:post_image, :title, :description)
    end
end
