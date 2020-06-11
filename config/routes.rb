Rails.application.routes.draw do
  root "posts#index"
  devise_for :users
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end
  resources :rooms, :only => [:show, :create] do
    resources :messages, :only => [:create]
  end

  resources :relationships, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
