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

    if request.format == :json
      @issue = Issue.where("volume = ?", params[:issue_volume]).find_by(year: params[:issue_year])
      @article = Article.find_by(submission_id: params[:submission_id])
      if @article.update_article_position(params[:article_position].eql?("article-up") ? "article-up" : "")
        on_success = true
      end
    else
      @article = Article.find(params[:id])
      if @article.update_attributes(article_params)
        return redirect_to @article
      else
        return render :edit
      end
    end
    render :json => { ok: on_success }
  end

  private
  def article_params
    params.require(:article).permit(:issue_id, :status, :pages, :external_link, :DOI, :issue_position)
  end
end
