class ArticleRevisionsController < ApplicationController
  before_action :admin?

  def new
    @article_revision = ArticleRevision.new
    @article_revision.submition = Submition.find(params[:submition_id])
    @article_revision.code = 'tekst_'
    @article_revision.version = @article_revision.submition.article_revisions.count + 1
    if @article_revision.version == 1
      @article_revision.received = @article_revision.submition.received
    else
      @article_revision.received = Time.now
    end
  end

  def create
    submition = Submition.find(params[:submition_id])
    @article_revision = ArticleRevision.new(article_revision_params)
    @article_revision.submition = submition
    if @article_revision.save
      redirect_to submition
    else
      render :new
    end
  end

  def destroy
    article_revision = ArticleRevision.find(params[:id])
    article_revision.destroy
    redirect_to article_revision.submition
  end

  private
  def article_revision_params
    params.require(:article_revision).permit(:code,:version,:received,:pages,:pictures)
  end
end
