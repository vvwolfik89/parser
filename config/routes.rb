Rails.application.routes.draw do
  get 'parts_imports/new'
  get 'parts_imports/create'
  root "spares#index"

  resources :parts_imports, only: [:new, :create]

  get "/spares", to: "spares#index"

  resources :parts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
