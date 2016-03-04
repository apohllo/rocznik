Rails.application.routes.draw do

  get "/404" => "errors#not_found"
  get "/500" => "errors#internal_server_error"

  resources :issues do
    get :prepare_form, on: :member
    patch :prepare, on: :member
    patch :publish, on: :member
    get :show_reviews, on: :member
    get :show_statistics, on: :member
    get :show_reviewers, on: :member
    get :count_institutions, on: :member
  end
  resources :public_issues, only: [:index,:show] do
    get :reviewers, on: :member
  end
  resources :people do
    get :search, on: :member
  end
  resources :submissions do
    post :send_decision, on: :member
  end
  resources :public_submissions, only: [:new, :create] do
    get :authors, on: :collection
    post :add_author, on: :collection
    post :cancel
  end
  resources :user_submissions, only: [:index, :show]
  resources :affiliations, only: [:new, :create, :destroy] do
    get :institutions, on: :collection
    get :countries, on: :collection
    get :departments, on: :collection
  end
  resources :authorships, only: [:new, :create, :destroy] do
    post :sign, on: :member
  end
  resources :reviews do
    post :ask, on: :member
    post :send_reminder, on: :member
    post :send_status, on: :member
    post :ask_for_review, on: :member
    get :accepted, on: :member
    get :rejected, on: :member
  end
  resources :public_reviews do
    get :new_reviewer, on: :collection
    post :create_reviewer, on: :collection
    get :finish, on: :collection
  end
  resources :article_revisions, only: [:new, :create, :destroy]
  resources :article_revisions
  resources :articles do
    get :generate_certificate, on: :member
  end  
  resource :profile, only: [:show, :edit, :update] do
    get :edit_password
    patch :update_password
  end
  resources :public_articles, only: [:show]
 
  get 'mails/write_email/:id', to: 'mails#write_email', as: :write_email
  post 'mails/send_email', to: 'mails#send_email', as: :send_email

  resources :users, only: [:new, :create] do
    get :new_person, on: :collection
    post :create_person, on: :collection
  end
  devise_for :users
  mount Storytime::Engine => "/"
  root to: "blog_posts#index"
end
