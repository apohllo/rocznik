class PublicArticlesController < ApplicationController
  before_action -> {set_title "Artykuł"}
  impressionist actions: [:show], unique: [:session_hash]

  def show
    @article = Article.find(params[:id])
  end
end
