Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"
  get '/menu', to: 'menu#index', as: :menu
  # get '/reservation', to: 'reservations#new', as: :new_reservation
  # post '/reservation', to: 'reservations#create', as: :reservations
  get '/contact', to: 'pages#contact', as: :contact
  
  resources :restaurants, only: [:index, :show] do
    resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :menu, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :tables, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      member do
        patch :update_status
      end
    end
    resources :reservations, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :orders, only: [:index, :show, :new, :create, :update] do
      collection do
        get :export
      end
      # resource :payment, only: [:create]
      # post :refund, to: 'payments#refund'
    end
  end
end



# The "API Mode" Trap
# When you created this current project, did you use the --api flag?
# Example: rails new resto_app --api
# If you did, Rails sometimes encourages you to skip :new and :edit because APIs don't use HTML forms. However, the router still generates them unless you explicitly tell it not to.