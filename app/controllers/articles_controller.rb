class ArticlesController < ApplicationController
  before_action :admin_required
  

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article
    else
      render :new
    end
  end
  

  def index
    @query_params = params[:q] || {}
    @query = Article.ransack(@query_params)
    @query.sorts = ['created_at'] if @query.sorts.empty?
    @articles = @query.result
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
    params.require(:article).permit(:issue_id, :status, :article_pages, :link_to_article)
  end
end
