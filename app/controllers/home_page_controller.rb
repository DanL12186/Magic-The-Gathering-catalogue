class HomePageController < ApplicationController

  def home
    cache_key = "iconic_cards#{Time.now.hour}"

    @iconic_cards = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      Card.where(iconic: true).limit(25).to_a
    end
  end

end