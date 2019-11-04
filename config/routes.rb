Rails.application.routes.draw do

  resources :categories, shallow: true do
    resources :posts
  end

  root "categories#index"
end
