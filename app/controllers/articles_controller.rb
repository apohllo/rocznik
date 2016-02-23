class ArticlesController < ApplicationController
  before_action :admin_required
  layout "admin"
  before_action -> {set_title "Artykuły"}

  def index
    @query_params = params[:q] || {}
    @query = Article.ransack(@query_params)
    @query.sorts = ['created_at'] if @query.sorts.empty?
    @articles = @query.result.includes(:submission)
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    on_success = false

    @article = Article.find(params[:id])
    if @article.update_attributes(article_params)
      on_success = true
      redirect_to @article unless request.format == :json
    else
      render :edit unless request.format == :json
    end
    render :json => { ok: on_success } if request.format == :json
  end

  private
  def article_params
    params.require(:article).permit(:issue_id, :status, :pages, :external_link, :DOI, :issue_position)
  end
end
