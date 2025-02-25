Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post 'users/sign_in', to: 'sessions#create', defaults: { format: :json }
  delete 'users/sign_out', to: 'sessions#destroy'
  get '/file', to: 'upload_files#show_public'
  resources :users, defaults: { format: :json } do
    collection do
      post 'sign_up'
    end
  end

  resources :upload_files, defaults: { format: :json }
end
