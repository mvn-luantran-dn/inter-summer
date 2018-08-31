Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'static_pages#home'
  get  '/help', to: 'static_pages#help'
  get  '/about', to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get '/auctions/:id', to: 'static_pages#show'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'auth/:provider/callback', to: 'omniauths#create'
  get 'auth/failure', to: redirect('/')
  get '/signup', to: 'users#new'
  resources :users do
    resources :orders
    get '/orders/:id', to: 'orders#edit'
    delete '/orders/:item_id', to: 'orders#destroy'
  end
  resources :products, :categories
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  get '/404', to: 'application#page_not_found', as: '/not_found'
  namespace :admin do
    root 'base#index'
    resources :auctions, :orders
    resources :users do
      member do
        get 'block'
      end
    end
    resources :categories do
      collection do
        get 'import', to: 'categories#show_import'
        post 'import', to: 'categories#import'
      end
    end
    resources :products do
      resources :timers
    end
    get '/sale/:id', to: 'status_products#sale', as: '/sale'
    get '/unsale/:id', to: 'status_products#unsale', as: '/unsale'
  end
  mount ActionCable.server => '/cable'
  get '/current_user' => 'users#id_current_user'
  get '/change/:id' => 'notifications#change'
end
