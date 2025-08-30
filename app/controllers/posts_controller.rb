class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]
  before_action :set_user, only: %i[ new create ]

  def send_to_page_1
    redirect_to "/home/1"
  end

  def index
    @page = params[:page] ? params[:page] : 1
    @global_posts = Post.order(created_at: :desc).page(@page).per(10)
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
            turbo_stream.replace("post_errors_div", partial: "posts/errors", locals: { post: @post })
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
