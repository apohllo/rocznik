Rails.application.routes.draw do


  resources :issues do
    get :prepare_form, on: :member
    patch :prepare, on: :member
    patch :publish, on: :member
  end
  resources :public_issues, only: [:index,:show]
  resources :people
  resources :submissions
  resources :affiliations, only: [:new, :create, :destroy] do
    get :institutions, on: :collection
    get :countries, on: :collection
    get :departments, on: :collection
  end
  resources :authorships, only: [:new, :create, :destroy]
  resources :reviews do
    post :ask, on: :member
  end
  resources :article_revisions, only: [:new, :create, :destroy]
  resources :articles

  devise_for :users
  mount Storytime::Engine => "/"
  root to: "blog_posts#index"
end
