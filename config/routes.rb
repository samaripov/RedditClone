Rails.application.routes.draw do
  get "users/new"
  post "users/create"
  get "users/edit"
  patch "users/update"
  delete "users/destroy"

  get "/login", to: "sessions#new", as: "new_session"
  post "/login", to: "sessions#create", as: "login_user"
  resources :passwords, param: :token
end
