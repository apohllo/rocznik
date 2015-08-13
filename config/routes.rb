Rails.application.routes.draw do
  resources 'people'
  resources 'affiliations', only: [:new, :create, :destroy]

  devise_for :users
  mount Storytime::Engine => "/"
  root to: "blog_posts#index"
end
