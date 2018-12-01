Rails.application.routes.draw do
  # module the controllers without affecting the URI
  scope module: :v2, constraints: ApiVersion.new('v2') do
    resources :comics, only: :index
  end

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :comics do
      resources :subscribers
      resources :pages do
        resources :comments
      end
    end

    # Favorites
    get 'favorites', to: 'subscribers#index_favorites'
    get 'favorites/:comic_id', to: 'subscribers#show_favorites'
    post 'favorites/:comic_id', to: 'subscribers#create_favorites'
    delete 'favorites/:comic_id', to: 'subscribers#destroy_favorites'

    # Login
    post 'auth/login', to: 'authentication#authenticate'
    post 'signup', to: 'users#create'
  end

  #comments
  # get 'comments/:comic_id/:page_id', to: 'comments#index'
  # post 'comments/:comic_id/:page_id', to: 'comments#create'
  # put 'comments/:comic_id/:page_id/:comment_id', to: 'comments#update'
  # delete 'comments/:comic_id/:page_id/:comment_id', to: 'comments#destroy'
end
