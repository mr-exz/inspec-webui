Rails.application.routes.draw do
  get 'main/index'
  resources :main do
    collection { post :import }
  end
  root 'main#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
