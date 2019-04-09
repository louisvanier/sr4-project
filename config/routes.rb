Rails.application.routes.draw do
  namespace :templates do
    resources :matrix_users
  end
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
