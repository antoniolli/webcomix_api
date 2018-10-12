Rails.application.routes.draw do
  # module the controllers without affecting the URI
  scope module: :v2, constraints: ApiVersion.new('v2') do
    resources :comics, only: :index
  end

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :comics do
      resources :pages
    end
  end

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
