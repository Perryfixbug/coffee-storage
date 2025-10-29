Rails.application.routes.draw do
  resources :ordered_products
  resources :orders
  resources :agencies do
    collection { get :search }
  end

  resources :products do
    collection { get :search }
  end
  resources :users
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  root "users#index"
end
