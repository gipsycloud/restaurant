Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"
  get '/menu', to: 'menu#index', as: :menu
  get '/reservation', to: 'reservations#new', as: :new_reservation
  post '/reservation', to: 'reservations#create', as: :reservations
  get '/contact', to: 'pages#contact', as: :contact
  
  resources :restaurants do
    resources :reservations
    resources :orders
    resources :tables
    resources :menu
  end
end
