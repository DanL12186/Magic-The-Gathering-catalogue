class HomePageController < ApplicationController

  def home
    @iconic_cards = Card.where(iconic: true)
  end

end