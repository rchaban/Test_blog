Rails.application.routes.draw do
  resources :users
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
  match '/users/setPublicKey', to: 'users#setPublicKey', via: 'post'
  

  resources :friendship, only: [:create, :accept, :decline, :cancel, :delete] do
    collection do
      get :create
      get :accept
      get :decline
      get :cancel
      get :delete
    end
  end

  resources :conversations do
    resources :messages
  end
  

end
