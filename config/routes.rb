Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :sessions, only: :index
  post "/upload" => 'sessions#upload'
  get "/video" => 'sessions#video'
  get "/auth/:provider/callback" => 'sessions#create'
end
