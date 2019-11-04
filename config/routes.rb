Rails.application.routes.draw do

  resources :categories, shallow: true do
    resources :posts, shallow: true
  end

  root "categories#index"
end
