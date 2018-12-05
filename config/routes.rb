Rails.application.routes.draw do
  root "application#home"

  get '/hand_odds_calculator' => 'application#hand_odds_calculator'
  post '/decks/calculate_custom_hand_odds' => 'decks#calculate_custom_hand_odds'

  get '/cards/find_by_properties'
  post '/cards/filter_search' => 'cards#filter_search'

  resources :cards
  resources :decks

  get '/decks/:id/overview' => 'decks#overview'
  
  get ':filter' => 'cards#filter'

end