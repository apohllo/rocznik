class ArticlesController < ApplicationController
  before_action :admin_required
  layout "admin"

  before_action -> {set_title "Artykuły"}
  impressionist actions: [:show], unique: [:session_hash]

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
      return redirect_to @article unless request.format == :json
    else
      return render :edit unless request.format == :json
    end
    render :json => { ok: on_success }
  end

  def generate_certificate
    @article = Article.find(params[:id])
    pdf=Certificate.new.generate_certificate(@article)

    send_data pdf.render, filename: 'certificate.pdf', type: "application/pdf"

  end

  private
  def article_params
    params.require(:article).permit(:issue_id, :status, :pages, :external_link, :DOI, :issue_position)
  end
end
