MyPaymentManager::Application.routes.draw do
  get "credit_cards/index"
  get "accounts/index"
  root :to => "home#index"
  devise_for :users, controllers: {registrations: "registrations"}
  resources :accounts_users, only: [:create, :new, :destroy]
  resources :users
  resources :accounts do
    resources :payments, only: [:create, :new]
  end
  get "accounts/:id/security" => "accounts_user#index", as: "account_security"
  resources :notes, only: [:create]
  resources :payments, only: [:create, :new]
  resources :credit_cards

  match "/about", to: "static_pages#about", via: :get
  match "/contact", to: "static_pages#contact", via: :get
  devise_scope :user do
    get "/login" => "devise/sessions#new"
  end
end