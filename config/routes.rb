Rails.application.routes.draw do
  resources :comics do
    resources :pages
  end
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
