Rails.application.routes.draw do
  resources :members do
    resources :friendships
  end

  root to: "members#index"
end
