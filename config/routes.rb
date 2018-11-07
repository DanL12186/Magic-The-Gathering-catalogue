Rails.application.routes.draw do
  root "application#home"

  resources :cards
  resources :decks

  get ':filter' => 'cards#filter'

end
