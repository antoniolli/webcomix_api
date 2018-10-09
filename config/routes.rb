Rails.application.routes.draw do
  resources :comics do
    resources :pages
  end
end
