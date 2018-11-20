Rails.application.routes.draw do
  root "application#home"

  post 'decks/calculate_custom_hands_odds' => 'decks#calculate_custom_hand_odds'
  get '/hand_odds_calculator' => 'application#hand_odds_calculator'

  resources :cards
  resources :decks
  
  get ':filter' => 'cards#filter'

end
