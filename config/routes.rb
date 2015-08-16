Rails.application.routes.draw do
  resources :people
  resources :submitions
  resources :affiliations, only: [:new, :create, :destroy]
  resources :authorships, only: [:new, :create, :destroy]
  resources :reviews
  resources :article_revisions, only: [:new, :create, :destroy]

  devise_for :users
  mount Storytime::Engine => "/"
  root to: "blog_posts#index"
end
