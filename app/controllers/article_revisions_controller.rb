class ArticleRevisionsController < ApplicationController
  before_action :admin?

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

  def destroy
    article_revision = ArticleRevision.find(params[:id])
    article_revision.destroy
    redirect_to article_revision.submission
  end

  private
  def article_revision_params
    params.require(:article_revision).permit(:code,:version,:received,:pages,:pictures)
  end
end
