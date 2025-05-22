require 'sidekiq/web'

Rails.application.routes.draw do
  get 'pdf/generate_pdf'

  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  resources :friends

  get 'posts/download_all_pdf', to: 'posts#download_all_pdf', as: 'download_all_pdf'

  resources :posts do
    resources :comments, only: [:create]

    member do
      get :download_pdf
      post :generate_pdf
    end
    collection do
      post :generate_all_pdf
    end
  end

  get 'home/about'
  root 'home#index'
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    get 'comments/index'
    get 'comments/destroy'
    get 'posts/index'
    resources :posts do
      resources :comments, only: [:index, :destroy]
    end
  end
end