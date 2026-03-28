Rails.application.routes.draw do
  get "locale/:locale", to: "locales#show", as: :locale_switch,
                        constraints: { locale: /en|hr/ }

  devise_for :users

  resource :profile, only: [ :show, :edit, :update ]

  resources :trips do
    resources :places, only: [:index, :create, :destroy], module: :trips do
      resources :comments, only: [:create, :destroy], module: :places, controller: :comments
    end
    resources :invitations, only: [ :create ], module: :trips
    resources :tickets, only: [:index, :new, :create, :show, :edit, :update, :destroy], module: :trips
  end

  get 'geocoding/autocomplete', to: 'geocoding#autocomplete'
  get 'geocoding/reverse', to: 'geocoding#reverse'

  resources :invitations, only: [ :index ], controller: :trip_invitations do
    member do
      post :accept
      post :decline
    end
  end

  root "dashboard#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
