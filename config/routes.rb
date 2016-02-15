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
  resources :reviews do
    post :ask, on: :member
  end
  resources :article_revisions, only: [:new, :create, :destroy]
  resources :article_revisions
  resources :articles
<<<<<<< HEAD
  resources :user_mailer
    get 'mail/write_email', to: 'mail#write_email', as: :write_email
    post 'mail/send_email', to: 'mail#send_email', as: :send_email
=======
  resources :public_articles, only: [:show]
>>>>>>> c34aaed3036613a8896dcfe2ae657bcdfad807dc

  devise_for :users
  mount Storytime::Engine => "/"
  root to: "blog_posts#index"
end
