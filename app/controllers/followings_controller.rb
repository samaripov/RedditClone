class FollowingsController < ApplicationController
  before_action :new_session_path

  def show_following
    render_users(current_user.followed_users, "You follow #{current_user.followed_users.count} users")
    
  end
  def show_followers
    render_users(current_user.followers, "You have #{current_user.followers.count} followers")
  end

  def follow
    user = User.find(params[:user_id])
    unless user
      flash[:alert] = "Dude, this user doesn't exist... Trust me bro."
    end
    followed_user = current_user.followings.create(followed_id: user.id)
    if followed_user.persisted?
      render_follow_button(user)
    else
      unless user
        flash[:alert] = "Couldn't follow user, please try again"
      end
    end
  end

  def unfollow
    user = User.find(params[:user_id])
    unless user
      flash[:alert] = "Dude, this user doesn't exist... Trust me bro."
    end
    if current_user.followings.exists?(followed_id: user.id)
      current_user.followings.find_by(followed_id: user.id)&.destroy
      render_follow_button(user)
    else
      unless user
        flash[:alert] = "Couldn't unfollow user, please try again"
      end
    end
  end

  private
    def require_login
      unless current_user
        redirect_to new_session_path
      end
    end
    def render_follow_button(user)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "followed_users_count",
              partial: "users/followed_users"
            ),
            turbo_stream.replace(
              "follow_button",
              partial: "users/follow_button",
              locals: { user: user, already_follow_user: current_user.followed_users.exists?(user.id) }
            )
          ]
        end
      end
    end
    def render_users(users, title)
      respond_to do |format|
        format.html { render template: "users/users_list", locals: { users: users, title: title } }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "main_content",
              html: render_to_string(template: "users/users_list", layout: false, locals: { users: users, title: title })
            )
          ]
        end
      end
    end
end
