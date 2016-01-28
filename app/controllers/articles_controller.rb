class ArticlesController < ApplicationController
  before_action :admin_required

  def index
    @articles = Article.order(:created_at)
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  private
  def article_params
    params.require(:article).permit(:issue_id, :status)
  end
end
