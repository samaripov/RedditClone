Rails.application.routes.draw do
  root "posts#index"
  get "/users/:userid/confirm_delete", to: "users#confirm_delete", as: "confirm_delete"
  resources :users, only: [ :show, :new, :create, :edit, :update, :destroy ] do
    resources :posts, only: [ :new, :create, :edit, :update, :destroy ]
  end

  get "/login", to: "sessions#new", as: "new_session"
  post "/login", to: "sessions#create", as: "login_user"
  delete "/logout", to: "sessions#destroy", as: "logout_user"
  resources :passwords, param: :token
end
