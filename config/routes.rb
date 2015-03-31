Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :sessions, only: :index
  get "/upload" => 'sessions#upload'
  get "/list" => 'sessions#list'
  get "/auth/:provider/callback" => 'sessions#create'
end
