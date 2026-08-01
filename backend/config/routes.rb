Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :users, only: [:show]
    resources :rewards, only: [:index]
    resources :redemptions, only: [:index, :create]
  end
end
