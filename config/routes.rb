Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
     resources :templates_matrix_users, only: [:index, :create, :destroy, :update]
    end
  end

  root to: 'lobby#index'
end
