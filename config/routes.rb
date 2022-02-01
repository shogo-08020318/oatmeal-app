Rails.application.routes.draw do
  root to: 'static_pages#top'

  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  resources :users, param: :uuid, only: %i[new show create]
  resources :foods, param: :uuid, only: %i[index show new create edit update]
end
