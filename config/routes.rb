Rails.application.routes.draw do
  devise_for :users
  require 'sidekiq/web'

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # get 'parts_imports/new'
  # get 'parts_imports/create'
  # root "parts#index"

  resources :parts_imports, only: [:new, :create]

  get "/spares", to: "spares#index"

  resources :parts do
    collection do
      get :daily_report
    end
  end
  resources :proxy_servers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
