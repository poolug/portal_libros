Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :books
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "books#index"

  # construcción del path para acceder al controlador#metodo
  patch "/books/:id/reserve", to: "books#reserve", as: "reserve"
  patch "/books/:id/not_reserve", to: "books#not_reserve", as: "not_reserve"
  patch "/books/:id/buy", to: "books#buy", as: "buy"
  patch "/books/:id/not_buy", to: "books#not_buy", as: "not_buy"
end
