class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
  
  def home
    @iconic_cards = Card.where(iconic: true)
  end
end
