Rails.application.routes.draw do
  
  controller :issues do
    get '/issues/:id/prepare', to: 'issues#prepare_form', as: 'issue_prepare_form'
	  patch '/issues/:id/prepare_update', to: 'issues#prepare', as: 'issue_prepare'
  end	
   
  
  resources :issues
  resources :people
  resources :submissions
  resources :affiliations, only: [:new, :create, :destroy] do
    get :autocomplete_institution_name, on: :collection
    get :autocomplete_country_name, on: :collection
    get :autocomplete_department_name, on: :collection
  end
  resources :authorships, only: [:new, :create, :destroy]
  resources :reviews
  resources :article_revisions, only: [:new, :create, :destroy]

  devise_for :users
  mount Storytime::Engine => "/"
  root to: "blog_posts#index"
end
