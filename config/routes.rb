MyPaymentManager::Application.routes.draw do
  get "credit_cards/index"
  get "accounts/index"
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  resources :accounts do
    resources :payments, only: [:create, :new]
  end
  resources :payments, only: [:create, :new]
  resources :credit_cards

  match "/about", to: "static_pages#about", via: :get
  match "/contact", to: "static_pages#contact", via: :get
end