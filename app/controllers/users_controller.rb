class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  before_action :set_current_user, only: %i[ edit update ]
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
    unless @user.authenticate(params[:user][:current_password])
      @user.errors.add(:current_password, "is incorrect")
      render :edit, status: :unprocessable_entity
      return
    end
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private
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
