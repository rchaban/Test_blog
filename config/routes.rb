Rails.application.routes.draw do
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :articles do
    resources :comments
  end 
  resources :sessions, only: [:new, :create, :destroy] 
  resources :microposts, only: [:create, :destroy]
  get 'welcome/index'
  match '/about', to: 'welcome#about', via: 'get'
  match '/contact', to: 'welcome#contact', via: 'get'
  match '/signup', to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  
end
