class FollowingsController < ApplicationController
  before_action :new_session_path

  def follow
    user = User.find(params[:user_id])
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "follow-button",
            partial: "users/followed_button",
            locals: { user: user }
          )
        ]
      end
    end
  end

  def unfollow
    user = User.find(params[:user_id])
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "follow-button",
            partial: "users/follow_button",
            locals: { user: user }
          )
        ]
      end
    end
  end

  private
    def require_login
      unless current_user
        redirect_to new_session_path
      end
    end
end
