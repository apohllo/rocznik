class ReviewsController < ApplicationController
  def index
    @reviews = Review.order('deadline desc').all
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = Review.new
    submition = Submition.find(params[:submition_id])
    @review.article_revision = submition.article_revisions.order(:created_at).last
    @review.status = 'wysłane zapytanie'
    @review.asked = Time.now
    @review.deadline = 45.days.from_now
  end

  def create
    article_revision = ArticleRevision.find(params[:article_revision_id])
    @review = Review.new(review_params)
    @review.article_revision = article_revision
    if @review.save
      redirect_to article_revision.submition
    else
      render :new
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(review_params)
      redirect_to @review
    else
      render :edit
    end
  end

  def destroy
    review = Review.find(params[:id])
    review.destroy
    redirect_to review.submition
  end

  private
  def review_params
    params.require(:review).permit(:person_id,:status,:asked,:deadline,:remarks,:general,:scope,:meritum,:language,:intelligibility,:literature,:novelty,:content)
  end
end
