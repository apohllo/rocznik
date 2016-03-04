class ArticleRevisionsController < ApplicationController
  before_action :admin_required
  layout "admin"
  before_action -> {set_title "Wersja artykułu"}

  def new
    @article_revision = ArticleRevision.new
    @article_revision.submission = Submission.find(params[:submission_id])
    @article_revision.code = 'tekst_'
    @article_revision.version = @article_revision.submission.article_revisions.count + 1
    if @article_revision.version == 1
      @article_revision.received = @article_revision.submission.received
    else
      @article_revision.received = Time.now
    end
  end

  def create
    submission = Submission.find(params[:submission_id])
    @article_revision = ArticleRevision.new(article_revision_params)
    @article_revision.submission = submission
    if @article_revision.save
      redirect_to submission
    else
      render :new
    end
  end

  def update
    @article_revision = ArticleRevision.find(params[:id])
    if @article_revision.update_attributes(article_revision_params)
      redirect_to @article_revision.submission
    else
      render :edit
    end
  end

  def edit
        @article_revision = ArticleRevision.find(params[:id])
  end

  def show
    @article_revision = ArticleRevision.find(params[:id])
  end

  def destroy
    article_revision = ArticleRevision.find(params[:id])
    article_revision.destroy
    redirect_to article_revision.submission
  end

  private
  def article_revision_params
    params.require(:article_revision).permit(:code,:version,:received,:pages,:pictures,:article,:comment,:accepted)
  end
end
