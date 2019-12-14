Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :categories, shallow: true do
    resources :posts, shallow: true do
      resources :post_images, only: :destroy
      resources :comments, shallow: true
    end
  end

  root "categories#index"
end
