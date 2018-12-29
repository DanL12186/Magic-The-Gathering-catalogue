class UsersController < ApplicationController
  def new
    redirect_if_logged_in
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save ? (session[:user_id] = @user.id; redirect_to root_path) : (render :new)
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :email, :password_confirmation)
  end
end
