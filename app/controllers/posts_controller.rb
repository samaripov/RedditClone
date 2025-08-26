class PostsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
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
