Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
     resources :templates_matrix_users, only: [:index, :create, :destroy, :update]
    end
  end

  authenticated :user do
    root to: 'lobby#index', as: :authenticated_root
  end
  root to: 'lobby#sign_in'

end
