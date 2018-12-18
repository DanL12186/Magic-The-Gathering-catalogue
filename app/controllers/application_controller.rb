class ApplicationController < ActionController::Base
  def home
    @iconic_cards = Card.where(iconic: true)
  end
end
