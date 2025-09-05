class CommentsController < ApplicationController
  before_action :require_login
  def new
    post = Post.find(params[:id])
    @comment = current_user.comments.build(post: post)
  end

  def create
  end

  def edit
  end

  def update
  end

  def delete
  end

  private
    def require_login
      unless current_user
        redirect_to new_session_path
      end
    end
end
