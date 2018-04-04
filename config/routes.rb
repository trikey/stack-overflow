Rails.application.routes.draw do
  resources :questions, shallow: true do
    resources :answers, except: [:index, :show]
  end
end
