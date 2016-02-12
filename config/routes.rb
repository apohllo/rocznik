Rails.application.routes.draw do


get "/404" => "errors#not_found"
get "/500" => "errors#internal_server_error"

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
  resources :public_reviews do
    get :new_reviewer, on: :collection
    post :create_reviewer, on: :collection
    get :finish, on: :collection
  end
  resources :reviews
  resources :article_revisions
  resources :articles

  devise_for :users
  mount Storytime::Engine => "/"
  root to: "blog_posts#index"
end
