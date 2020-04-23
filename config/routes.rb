Rails.application.routes.draw do
  root to: "tasks#index"
  devise_for :users
  resources :tags
  resources :tasks do
    member do
      get :change_status
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
