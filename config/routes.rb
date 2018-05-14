Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  resources :questions, concerns: :votable, shallow: true do
    resources :answers, concerns: :votable, except: [:index, :show, :new] do
      patch :best, on: :member
    end
  end

  root to: 'questions#index'
end
