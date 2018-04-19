Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, except: [:index, :show, :new] do
      patch :best, on: :member
    end
  end

  root to: 'questions#index'
end
