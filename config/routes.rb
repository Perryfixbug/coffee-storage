Rails.application.routes.draw do
  resources :ordered_products
  resources :orders
  resources :import_orders, controller: "import_orders"
  resources :export_orders, controller: "export_orders"
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
