class PublicArticlesController < ApplicationController
  before_action -> {set_title "Artykuł"}

  def show
    @article = Article.find(params[:id])
  end
end
