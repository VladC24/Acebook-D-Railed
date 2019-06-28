# frozen_string_literal: true

Rails.application.routes.draw do
  get 'users/new'
  get 'posts/index'
  get 'users/search' => 'users#search'
  post 'users/:user_id/posts/:id/edit' => 'posts#edit'
  patch '/users/:user_id/posts/:id' => 'posts#update'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sessions
  resources :users do
    resources :posts
  end

  resources :posts do
    resources :likes
  end

  root 'users#new'
end
