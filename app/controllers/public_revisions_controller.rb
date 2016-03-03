class PublicRevisionsController < ApplicationController
  before_action -> {set_title "Rewizje"}

  def new
    @revision = ArticleRevision.new
    @revision.submission = Submission.find(params[:submission_id])
    @revision.code = 'tekst_'
    @revision.version = @revision.submission.article_revisions.count + 1
    @revision.received = Time.now
  end

  def create
    submission = Submission.find(params[:submission_id])
    @revision = ArticleRevision.new(article_revision_params)
    @revision.submission = submission
    if @revision.save
      redirect_to submission
    else
      render :new
    end
  end

  def show
    @revision = ArticleRevision.find(params[:id])
  end

  private
  def article_revision_params
    params.require(:article_revision).permit(:code,:version,:received,:pages,:pictures,:article,:comment,:accepted)
end

end
