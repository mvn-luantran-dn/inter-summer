Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help', to: 'static_pages#help'
  get  '/about', to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'auth/:provider/callback', to: 'omniauths#create'
  get 'auth/failure', to: redirect('/')
  get '/signup', to: 'users#new'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :products, only: %i[show]
  namespace :admin do
    root 'base#index'
    resources :users, :categories, :products, :auctions, :orders
    get '/sale/:id', to: 'status_products#sale', as: '/sale'
    get '/unsale/:id', to: 'status_products#unsale', as: '/unsale'
  end
end
