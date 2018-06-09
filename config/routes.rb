Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions, concerns: [:votable, :commentable], shallow: true do
    resources :answers, concerns: [:votable, :commentable], except: [:index, :show, :new] do
      patch :best, on: :member
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
