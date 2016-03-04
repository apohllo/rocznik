class PublicRevisionsController < ApplicationController
  before_action -> {set_title "Rewizje"}

  def new
    @revision = ArticleRevision.new
    @revision.submission = Submission.find(params[:submission_id])
  end

  def create
    @revision = ArticleRevision.new(article_revision_params)
    @revision.code = 'tekst_'
    submission = Submission.find(article_revision_params[:submission_id])
    @revision.version = submission.article_revisions.count + 1
    @revision.received = Time.now
    if @revision.save
      PublicRevisionMailer.notification(revision).deliver_now
      redirect_to user_submission_path(submission)
    else
      render :new
    end
  end

  def show
    @revision = ArticleRevision.find(params[:id])
  end

  private
  def article_revision_params
    params.require(:article_revision).permit(:code,:version,:received,:pages,:pictures,:article,:comment,:accepted,:submission_id)
end

end
