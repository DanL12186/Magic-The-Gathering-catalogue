class HomePageController < ApplicationController

  def home
    @iconic_cards = Card.where(iconic: true).limit(50)
  end

end
