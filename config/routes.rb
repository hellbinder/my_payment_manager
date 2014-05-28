MyPaymentManager::Application.routes.draw do
  get "accounts/index"
  get "accounts/show"
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  resources :accounts

  match "/about", to: "static_pages#about", via: :get
  match "/contact", to: "static_pages#contact", via: :get
end