class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  before_action :set_current_user, only: %i[ edit update destroy ]
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      respond_to do |format|
        format.html { redirect_to @user }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("navbar_frame", partial: "users/navbar"),
            turbo_stream.replace("main_content", html: render_to_string(template: "posts/index", layout: false, locals: { global_posts: Post.order(created_at: :desc).page(1).per(10) }))
          ]
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if !@user.authenticate(params[:user][:current_password])
        @user.errors.add(:current_password, "is incorrect")
        refresh_form_errors(format, "Update")
      elsif @user.update(user_params)
        format.html { redirect_to @user }
      else
        refresh_form_errors(format, "Update")
      end
    end
  end

  def confirm_delete
    @user = current_user
  end

  def destroy
    unless @user.authenticate(params[:user][:current_password])
      @user.errors.add(:current_password, "is incorrect")
      render :confirm_delete, status: :unprocessable_entity
      return
    end
    @user.destroy
    reset_session
  end

  private
    def refresh_form_errors(format, action)
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "errors_div",
          partial: "layouts/errors",
          locals: { entity: current_user }
        ), status: :unprocessable_entity
      end
    end
    def set_current_user
      @user = current_user
    end
    def user_params
      params.require(:user).permit(:avatar, :username, :email_address, :password, :password_confirmation)
    end
    def update_params
      params.require(:user).permit(:avatar, :username, :email_address, :password, :password_confirmation, :current_password)
    end
end
