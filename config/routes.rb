Rails.application.routes.draw do
  root "application#home"

  resources :cards
  resources :decks

  get '/hand_odds_calculator' => 'application#hand_odds_calculator'
  get ':filter' => 'cards#filter'

end
