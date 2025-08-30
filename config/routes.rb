Rails.application.routes.draw do
  root "sessions#new"
  get "/home", to: "posts#send_to_page_1", as: "home"
  get "/home(/:page)", to: "posts#index", as: "posts"
  get "/users/:userid/confirm_delete", to: "users#confirm_delete", as: "confirm_delete"
  get "/users/:id/(/:page)", to: "users#show"
  resources :users, only: [ :new, :create, :edit, :update, :destroy ] do
    resources :posts, only: [ :new, :create, :edit, :update, :destroy ]
  end

  get "/login", to: "sessions#new", as: "new_session"
  post "/login", to: "sessions#create", as: "login_user"
  delete "/logout", to: "sessions#destroy", as: "logout_user"
  resources :passwords, param: :token
end
