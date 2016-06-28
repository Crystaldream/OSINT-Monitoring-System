Rails.application.routes.draw do

  devise_for :users
  root 'index#index'

  resources :searches do
    collection do
      get 'run', to: 'searches#run'
      get 'start', to: 'searches#start'
    end
  end

  resources :bots

  resources :settings

end
