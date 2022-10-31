Rails.application.routes.draw do
  resources :produtos
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'produtos#index'

  resources :produtos do
    post :filtrar, on: :collection
    get 'produtos/:page', to: 'produtos#index'
    post :historico, on: :collection
  end

  resources :carrinhos do
    collection do
      post :busca_produtos
    end
  end

  patch ':controller', action: :filtrar
end
