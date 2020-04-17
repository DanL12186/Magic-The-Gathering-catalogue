class SessionsController < ApplicationController

  def new
    redirect_if_logged_in
    @user = User.new
  end

  def create
    @user = User.find_by(name: session_params[:name])
    session[:user_id] = @user.id if @user&.authenticate(session_params[:password])
    if session[:user_id]
      redirect_to root_path
    else
      render json: 'Authentication failed'.to_json
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  private

  def session_params
    params.require(:user).permit(:password, :name)
  end

end