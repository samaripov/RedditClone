class PostsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @user = current_user
    @post = current_user.posts.build
  end

  def create
    @user = current_user
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  private
    def post_params
      params.require(:post).permit(:title, :description)
    end
end
