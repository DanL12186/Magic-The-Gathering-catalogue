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

  #temporary before sets are their own class
  def edition
    @cards = Card.where(edition: params[:edition]).sort_by(&:multiverse_id)
  end

  def artist
    @cards = Card.where(artist: params[:artist]).sort_by { | card | [ card.multiverse_id, card.color ] }.uniq(&:name)
  end
  
end