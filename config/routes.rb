Rails.application.routes.draw do
  resources :postcode_searches, only: [:create]
  root "postcode_searches#new"
end
