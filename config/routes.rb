Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'static_pages#top'

  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider

  resources :users, param: :uuid, only: %i[new show create]
  resources :foods, param: :uuid, only: %i[index show new create edit update destroy] do
    resources :comments, only: %i[create destroy], shallow: true
  end

  resource :profile, only: %i[show edit update]
  resources :favorites, only: %i[create destroy]
  resources :password_resets

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
