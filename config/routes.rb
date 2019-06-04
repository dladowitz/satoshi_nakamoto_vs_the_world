# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root to: "landing_pages#home"

  resources :trackers

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'user_sign_out', :to => 'devise/sessions#destroy', :as => :destroy_devise_user_session
  end
end
