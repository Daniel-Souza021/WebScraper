Rails.application.routes.draw do
  resources :produtos
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'produtos#index'

  resources :produtos do
    post :filtrar, on: :collection
    get 'produtos/index/:page' , to: 'produtos#index'
  end
end
