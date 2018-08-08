# frozen_string_literal: true

Rails.application.routes.draw do
  get 'static_pages/home'
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get 'sessions/new'
  get 'password_resets/new'
  get 'password_resets/edit'
  get  '/signup',  to: 'users#new'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
