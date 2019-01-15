Rails.application.routes.draw do
  root "home_page#home"

  get "/login" => "sessions#new"
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  get '/artists/:artist' => 'application#artist'
  get 'sets/:edition/' => 'application#edition'
  get '/cards/color/:color' => 'cards#color'

  get '/about' => 'application#about'

  get '/hand_odds_calculator' => 'application#hand_odds_calculator'
  post '/decks/calculate_custom_hand_odds' => 'decks#calculate_custom_hand_odds'

  get '/cards/find_by_properties'
  post '/cards/find_by_properties' => 'cards#filter_search'

  get '/cards/card_names' => 'cards#card_names'
  
  post '/cards/update_prices' => 'cards#update_prices'

  get '/cards/search_results' => 'cards#search_results'

  resources :cards, except: [:new, :edit, :create, :destroy, :index]
  resources :users, except: [:index]
  resources :decks

  get '/cards/:name' => 'cards#show'

  get '/decks/:id/overview' => 'decks#overview'
end