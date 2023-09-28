Rails.application.routes.draw do

  root 'users#index'

  devise_for :users

  resources 'users' do
    collection do
      get :search
    end
   resources :conversations, only: [:index, :new, :create] do
     collection do
       get :search
     end
      resources :messages
    end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
