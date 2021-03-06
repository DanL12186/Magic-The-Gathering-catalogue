Rails.application.routes.draw do
  root "home_page#home"

  get "/login" => "sessions#new"
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  get "/signup" => "users#new"
  post '/signup' => "users#create"

  get '/cards/find_by_properties'
  post '/cards/find_by_properties' => 'cards#filter_search'

  get '/cards/reserved_list' => 'cards#reserved_list'

  get '/cards/search_results' => 'cards#search_results'
  get '/cards/card_names' => 'cards#card_names'
  get '/cards/card_names_with_editions' => 'cards#card_names_with_editions'
  get '/cards/:edition/' => 'cards#edition'
  get '/cards/artists/:artist' => 'cards#artist'
  get '/cards/color/:color' => 'cards#color'

  get '/cards/:edition/:name' => 'cards#show', as: 'card'

  get '/about' => 'application#about'

  get '/editions' => 'editions#index'

  get '/editions/open_booster_pack/' => 'editions#open_booster_pack'
  post '/editions/open_booster_pack/' => 'editions#open_booster_pack'

  get '/hand_odds_calculator' => 'application#hand_odds_calculator'
  post '/decks/calculate_custom_hand_odds' => 'decks#calculate_custom_hand_odds'
  
  post '/cards/update_prices' => 'cards#update_prices'

  resources :users, except: [:index]
  resources :decks, except: [:create]
  get '/decks/:id/sample_hand' => 'decks#sample_hand'

  resources :collections, except: [:edit, :create]
  
  #js-created cards
  post '/decks/create'
  post '/collections/create'

  #render error 404 if route doesn't exist
  match '*path' => 'application#render_404', via: :all
end