class PostsController < ApplicationController
  before_action :set_user, only: %i[ new create ]
  def index
    @user = current_user
    @global_posts = Post.all
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
            turbo_stream.replace("creating_a_post", partial: "users/create_form_link")
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
