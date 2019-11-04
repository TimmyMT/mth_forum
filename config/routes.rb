Rails.application.routes.draw do

  devise_for :users

  resources :categories, shallow: true do
    resources :posts, shallow: true
  end

  root "categories#index"
end
