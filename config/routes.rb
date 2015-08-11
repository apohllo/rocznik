Rails.application.routes.draw do
  devise_for :users
  mount Storytime::Engine => "/"
  root to: "blog_posts#index"
end
