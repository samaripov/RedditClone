Rails.application.routes.draw do
  get "users/new"
  get "users/create"
  get "users/edit"
  get "users/update"
  get "users/destroy"
  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create", as: "login_user"
  resources :passwords, param: :token
end
