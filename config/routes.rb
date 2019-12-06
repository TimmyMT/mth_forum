Rails.application.routes.draw do

  devise_for :users

  resources :categories, shallow: true do
    resources :posts, shallow: true do
      resources :comments, shallow: true
    end
  end

  root "categories#index"
end
