class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  before_action :set_current_user, only: %i[ edit update destroy ]
  def show
    @user = User.find(params[:id])
    @show_actions = @user == current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_url
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
        refresh_form(format, "Update")
      elsif @user.update(user_params)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "user_profile",
              partial: "users/user"
            ),
            turbo_stream.replace("profile_actions", partial: "users/profile_actions")
          ]
        end
      else
        refresh_form(format, "Update")
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
    redirect_to login_user_path
  end

  private
    def refresh_form(format, action)
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "user_errors_div",
          partial: "users/errors",
          locals: { user: current_user }
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
