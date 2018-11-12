class ApplicationController < ActionController::Base
  def home
    @cards = Card.all
  end
end
