Rails.application.routes.draw do
  root "home_page#home"

  get "/login" => "sessions#new"
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  get '/cards/find_by_properties'
  post '/cards/find_by_properties' => 'cards#filter_search'

  get '/cards/search_results' => 'cards#search_results'
  get '/cards/card_names' => 'cards#card_names'
  get '/cards/:edition/' => 'cards#edition'
  get '/cards/artists/:artist' => 'cards#artist'
  get '/cards/color/:color' => 'cards#color'

  get '/cards/:edition/:name' => 'cards#show'

  get '/about' => 'application#about'

  get '/hand_odds_calculator' => 'application#hand_odds_calculator'
  post '/decks/calculate_custom_hand_odds' => 'decks#calculate_custom_hand_odds'
  
  post '/cards/update_prices' => 'cards#update_prices'

  resources :users, except: [:index]
  resources :decks

  get '/cards/:name' => 'cards#show'

  get '/decks/:id/overview' => 'decks#overview'
end