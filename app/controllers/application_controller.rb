class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    session[:user_id] ? @@current_user ||= User.find(session[:user_id]) : @@current_user = nil
  end

  def logged_in?
    !!current_user
  end

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
  
end