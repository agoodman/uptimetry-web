Uptimetry::Application.routes.draw do

  match 'billing/post_back' => "billing#post_back", :via => :post, :as => 'billing_post_back'

  resources :plans, :only => [ :create, :index ] do
    collection do
      post :select
    end
  end

  resources :users, :only => [ :new, :create, :update ]
  resources :domains do
    resources :endpoints #, controller: 'domains/endpoints'
  end
  resources :endpoints do
    member do
      get :refresh
      get :remove
    end
  end

  match 'endpoints/:secret_key/up' => 'endpoints#up'
  match 'endpoints/:secret_key/down' => 'endpoints#down'
  resource :account, :only => [ :show ]
  resource :session, :only => [ :new, :create, :destroy ]
  resources :sessions, :only => [ :new, :create, :destroy ]
  match '/subscriptions/post_back' => 'subscriptions#post_back', :via => :post
  
  namespace :api do
    resource :session, :only => [ :create, :destroy ]
    resources :sessions, :only => [ :create, :destroy ]
    resource :user, :only => [ :show, :update, :destroy ]
    resources :users, :only => :create
    resources :domains
    resources :endpoints
  end

  match 'sign_up' => 'users#new', :as => 'sign_up'
  match 'sign_in' => 'sessions#new', :as => 'sign_in'
  match 'sign_out' => 'sessions#destroy', :via => [:get, :delete], :as => 'sign_out'
  
  root :to => "welcome#index"
end
