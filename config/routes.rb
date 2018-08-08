# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sessions/new'
  get 'password_resets/new'
  get 'password_resets/edit'
  get  '/signup',  to: 'users#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
