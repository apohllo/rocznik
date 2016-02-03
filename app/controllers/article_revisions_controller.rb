class ArticleRevisionsController < ApplicationController
  before_action :admin_required

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

  def index
    id = params[:issue_id]
    @issue_id = id
    @article_revisions = ArticleRevision.joins(:submission).where(submissions: { issue_id: id })
  end

  def update
    submission = Submission.find(params[:submission_id])
    @article_revision = ArticleRevision.find(params[:id])
    @article_revision.submission = submission
    if @article_revision.update_attributes(article_revision_params)
      redirect_to @article_revision.submission
    else
      render :edit
    end
  end

  def edit
    submission = Submission.find(params[:submission_id])
    if submission.status == 'nadesłany'
      @article_revision = ArticleRevision.find(params[:id])
    else
      redirect_to submission
    end
  end

  def show
    submission = Submission.find(params[:submission_id])
    @article_revision = ArticleRevision.find(params[:id])
    @article_revision.submission = submission
  end

  def destroy
    article_revision = ArticleRevision.find(params[:id])
    article_revision.destroy
    redirect_to article_revision.submission
  end

  private
  def article_revision_params
    params.require(:article_revision).permit(:code,:version,:received,:pages,:pictures,:article,:comment,:acceptation)
  end
end
