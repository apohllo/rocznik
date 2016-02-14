Rails.application.routes.draw do

<<<<<<< HEAD
=======

get "/404" => "errors#not_found"
get "/500" => "errors#internal_server_error"

>>>>>>> e933750cf1c5172da20c6930f5655b0a7980a61e
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
<<<<<<< HEAD
  resources :reviews do
    post :ask, on: :member
  end
  resources :article_revisions, only: [:new, :create, :destroy]
=======
  resources :reviews
  resources :article_revisions
>>>>>>> e933750cf1c5172da20c6930f5655b0a7980a61e
  resources :articles

  devise_for :users
  mount Storytime::Engine => "/"
  root to: "blog_posts#index"
end
