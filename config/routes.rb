Rails.application.routes.draw do
  root "posts#index"
  get "/explore", to: "posts#index", as: "posts"
  get "/camp", to: "posts#followings_posts", as: "camp"
  get "/users/:userid/confirm_delete", to: "users#confirm_delete", as: "confirm_delete"
  resources :users, only: [ :show, :new, :create, :edit, :update, :destroy ] do
    resources :posts
  end

  get "/followings/:user_id", to: "followings#show_following", as: "user_follows"
  get "/followers/:user_id", to: "followings#show_followers", as: "users_followers"
  post "/follow/:user_id", to: "followings#follow", as: "follow_user"
  delete "/unfollow/:user_id", to: "followings#unfollow", as: "unfollow_user"

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

  mount ActionCable.server => "/cable"
end
