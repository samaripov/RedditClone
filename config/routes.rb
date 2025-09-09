Rails.application.routes.draw do
  get "followings/follow"
  get "followings/unfollow"
  root "posts#index"
  get "/home", to: "posts#index", as: "posts"
  get "/users/:userid/confirm_delete", to: "users#confirm_delete", as: "confirm_delete"
  resources :users, only: [ :show, :new, :create, :edit, :update, :destroy ] do
    resources :posts
  end

  resources :posts do
    resources :comments, only: [ :new, :create, :destroy ]
  end
  get "/liked_posts", to: "posts#show_users_liked_posts", as: "users_liked_posts"
  post "/like_post/:id", to: "liked_posts#like_post", as: "like_post"
  delete "/unlike_post/:id", to: "liked_posts#unlike_post", as: "unlike_post"
  get "/login", to: "sessions#new", as: "new_session"
  post "/login", to: "sessions#create", as: "login_user"
  delete "/logout", to: "sessions#destroy", as: "logout_user"
  resources :passwords, param: :token
end
