Rails.application.routes.draw do
  root "application#home"

  mount PgHero::Engine, at: "pghero"

  get '/about' => 'application#about'

  get '/hand_odds_calculator' => 'application#hand_odds_calculator'
  post '/decks/calculate_custom_hand_odds' => 'decks#calculate_custom_hand_odds'

  get '/cards/find_by_properties'
  post '/cards/filter_search' => 'cards#filter_search'

  get '/cards/card_names' => 'cards#card_names'
  # post '/' => 'application#home'
  
  post '/cards/update_prices' => 'cards#update_prices'

  resources :cards
  resources :decks

  get '/cards/:name' => 'cards#show'

  get '/decks/:id/overview' => 'decks#overview'
  
  get ':filter' => 'cards#filter'
end