Rails.application.routes.draw do
  resources :users, only: [ :new, :create, :edit, :update, :destroy ]

  get "/login", to: "sessions#new", as: "new_session"
  post "/login", to: "sessions#create", as: "login_user"
  resources :passwords, param: :token
end
