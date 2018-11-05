Rails.application.routes.draw do
  root "application#home"

  resources :cards
  get ':filter' => 'cards#filter'
  

  #get "/users/:id/shows/all/favorite_characters" => "characters#favorite_characters"
end
