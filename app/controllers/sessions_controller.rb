class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    if authenticated?
      respond_to do |format|
        format.html { redirect_to posts_path }
        show_logged_in_view(format)
      end
    end
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      respond_to do |format|
        show_logged_in_view(format)
      end
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    Current.session = nil
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("navbar_frame", partial: "users/navbar"),
          turbo_stream.replace("main_content", html: render_to_string(template: "sessions/new", latout: false))
        ]
      end
    end
  end

  private
    def show_logged_in_view(format)
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("navbar_frame", partial: "users/navbar"),
          turbo_stream.replace("main_content", html: render_to_string(template: "posts/index", layout: false, locals: { global_posts: Post.order(created_at: :desc).page(1).per(10) }))
        ]
      end
    end
end
