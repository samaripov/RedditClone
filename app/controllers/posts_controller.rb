class PostsController < ApplicationController
  before_action :set_user, only: %i[ new create ]
  def index
    @posts = current_user.posts
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
        format.html { redirect_to @post }
        format.turbo_stream { render turbo_stream: turbo_stream.append("posts", @post) }
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
      params.require(:post).permit(:title, :description)
    end
end
