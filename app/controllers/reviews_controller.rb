class ReviewsController < ApplicationController
  before_action :admin_required

  def index
    @reviews = Review.order('deadline asc').all
    @query_params = params[:q] || {}
    @query = Review.ransack(@query_params)
    @query.sorts = ['deadline asc'] if @query.sorts.empty?
    @reviews = @query.result(distinct: true)
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = Review.new
    if params[:submission_id]
      submission = Submission.find(params[:submission_id])
      @review.article_revision = submission.article_revisions.order(:created_at).last
      if @review.article_revision.nil?
        flash[:error] = 'Zgłoszenie nie posiada przypisanych wersji!'
        redirect_to submission
        return
      end
    end
    if params[:person_id]
      person = Person.find(params[:person_id])
      @review.person = person
    end
    @review.status = 'wysłane zapytanie'
    @review.asked = Time.now
    @review.deadline = 45.days.from_now
  end

  def create
    @review = Review.new(review_params)
    if params[:article_revision_id]
      article_revision = ArticleRevision.find(params[:article_revision_id])
      @review.article_revision = article_revision
      if @review.save
        redirect_to article_revision.submission
      else
        render :new
      end
    elsif params[:person_id]
      person = Person.find(params[:person_id])
      @review.person = person
      if @review.save
        redirect_to person
      else
        render :new
      end
    else
      flash[:error] = 'Niepoprawne wywołanie'
      redirect_to submissions_path
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
    redirect_to review.submission
  end

  private
  def review_params
    params.require(:review).permit(:person_id,:status,:asked,:deadline,:remarks,:content,:article_revision_id)
  end
end
