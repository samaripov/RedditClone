class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post
  def new
    @comment = current_user.comments.build(post: @post)
  end

  def create
    @comment = current_user.comments.build(**comment_params, **{ post: @post })
    respond_to do |format|
      if @comment.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("comment-form", partial: "comments/form", locals: { comment: current_user.comments.build(post: @post) }),
            turbo_stream.prepend("comments-for-post-#{@post.id}", partial: "comments/comment", locals: { comment: @comment })
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("errors_div", partial: "layouts/errors", locals: { entity: @comment })
          ], status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    if @comment
      @comment.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("comment-#{@comment.id}")
        end
      end
    end
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end
    def require_login
      unless current_user
        redirect_to new_session_path
      end
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
