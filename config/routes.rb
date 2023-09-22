Rails.application.routes.draw do
  devise_for :users
  resources 'users' do
    resources :conversations do
      resources :messages
    end
  end
  root 'users#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
