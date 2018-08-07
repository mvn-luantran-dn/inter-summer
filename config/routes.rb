# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sessions/new'
  post 'sessions/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
