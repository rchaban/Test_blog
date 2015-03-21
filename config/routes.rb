Rails.application.routes.draw do
  get 'users/new'

  resources :articles do
    resources :comments
  end  
  get 'welcome/index'
  match '/about', to: 'welcome#about', via: 'get'
  match '/contact', to: 'welcome#contact', via: 'get'
  match '/signup', to: 'users#new', via: 'get'

  
end
