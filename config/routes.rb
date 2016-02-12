Rails.application.routes.draw do


  resources :issues do
    get :prepare_form, on: :member
    patch :prepare, on: :member
    patch :publish, on: :member
    get :show_reviews, on: :member
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
    get :new_reviewer, on: :collection
    post :create_reviewer, on: :collection
    get :finish, on: :collection
  end
  resources :article_revisions
  resources :articles

  devise_for :users
  mount Storytime::Engine => "/"
  root to: "blog_posts#index"
end
