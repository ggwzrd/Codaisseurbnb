Rails.application.routes.draw do
  resources :themes
  get 'pages/home'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#home'
  resources :users, only: [:show]
  resources :rooms
end
