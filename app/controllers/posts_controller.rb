class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]
  before_action :set_user, only: %i[ new edit update create ]

  def index
    @page = params[:page] ? params[:page] : 1
    @global_posts = Post.order(created_at: :desc).page @page
  end

  def show
    @post = current_user.posts.find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("main_content", html: render_to_string(template: "posts/show", layout: false))
        ]
      end
    end
  end

  def new
    @post = current_user.posts.build
  end
  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        @user = current_user
        format.html { redirect_to root_path }
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
    @post = current_user.posts.find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("main_content", html: render_to_string(template: "posts/edit", layout: false))
        ]
      end
    end
  end
  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("main_content", html: render_to_string(template: "posts/show", layout: false))
          ]
        end
      end
    else
      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("main_content", html: render_to_string(template: "posts/edit", layout: false))
          ]
        end
      end
    end
  end
  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("main_content", html: render_to_string(template: "posts/index", layout: false, locals: { global_posts: Post.order(created_at: :desc).page(1).per(10) }))
        ]
      end
    end
  end

  private
    def set_user
      @user = current_user
    end
    def post_params
      params.require(:post).permit(:post_image, :title, :description)
    end
end
