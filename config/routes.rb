require 'sidekiq/web'
Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  resources :searches, only: [:index]

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', confirmations: 'confirmations' }

  devise_scope :user do
    post :set_email, controller: :omniauth_callbacks, as: :set_user_email
  end

  use_doorkeeper

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions, concerns: [:votable, :commentable], shallow: true do
    resources :answers, concerns: [:votable, :commentable], except: [:index, :show, :new] do
      patch :best, on: :member
    end
    resources :subscribes, only: [:create, :destroy], shallow: true
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
