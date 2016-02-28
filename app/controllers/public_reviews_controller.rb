class PublicReviewsController < ApplicationController
  before_action -> {set_title "Recenzje"}

  def new_reviewer
    @person = Person.new
  end

  def create_reviewer
    @person = Person.where(email: params[:person][:email]).first
    unless @person
      @person = Person.new(person_params)
      unless @person.save
        render :new_reviewer
        return
      end
    end
    @revision = ArticleRevision.find(params[:revision_id])
    Review.create!(person: @person, article_revision: @revision,
                   asked: Time.now, status:params[:status])
    @person = Person.new
    flash[:success] = 'Pozycja została dodana pomyślnie.'
    render :new_reviewer
  end

  def finish
    flash[:success] = 'Dziękujemy za zgłoszenie'
  end

  def new
    @public_review = Review.new
    if params[:submission_id]
      submission = Submission.find(params[:submission_id])
      @public_review.article_revision = submission.article_revisions.order(:created_at).last
      if @public_review.article_revision.nil?
        flash[:error] = 'Zgłoszenie nie posiada przypisanych wersji!'
        redirect_to submission
        return
      end
    end
    if params[:person_id]
      person = Person.find(params[:person_id])
      @public_review.person = person
    end
    @public_review.asked = Time.now
    @public_review.deadline = 45.days.from_now
  end

  def create
    @public_review = Review.new(review_params)
    @public_review.status = 'wysłane zapytanie'
    if review_params[:article_revision_id]
      article_revision = ArticleRevision.find(review_params[:article_revision_id])
      @public_review.article_revision = article_revision
      if @public_review.save
        AddedReviewMailer.public_review_notification(@public_review).deliver_later
        render :saving_info
      else
        render :new
      end
    elsif review_params[:person_id]
      person = Person.find(review_params[:person_id])
      @public_review.person = person
      if @public_review.save
        redirect_to person
      else
        render :new
      end
    else
      flash[:error] = 'Niepoprawne wywołanie'
      redirect_to submissions_path
    end
  end

  private
  def review_params
    params.require(:review).permit(:person_id,:asked,:deadline,:remarks, :content, :general,:scope,:meritum,:language,:intelligibility,:literature,:novelty,:content,:article_revision_id)
  end

  def person_params
    params.require(:person).permit(:name,:surname,:email,:sex,roles: [])
  end
end
