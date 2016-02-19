class PublicRevisionsController < ApplicationController

  def new
    @public_revision = PublicRevision.new
    @public_revision.submission = Submission.find(params[:submission_id])
    @public_revision.code = 'tekst_'
    @public_revision.received = Time.now
  end

  def create
    submission = Submission.find(params[:submission_id])
    @public_revision = PublicRevision.new(public_revision_params)
    @public_revision.submission = submission
    if @public_revision.save
      redirect_to submission
    else
      render :new
    end
  end

  private
  def public_revision_params
    params.require(:public_revision).permit ( :status, :file, :pages, :pictures, :received )
  end

end
