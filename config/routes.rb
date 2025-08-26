Rails.application.routes.draw do
  get "posts/index"
  get "posts/show"
  get "posts/new"
  get "posts/edit"
  root "users#show"

  resources :users, only: [ :new, :create, :edit, :update, :destroy ]

  get "/login", to: "sessions#new", as: "new_session"
  post "/login", to: "sessions#create", as: "login_user"
  delete "/logout", to: "sessions#destroy", as: "logout_user"
  resources :passwords, param: :token
end
