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

  def edit
    @review = Review.find(params[:id])
    @allowedStatus = {
      Review::STATUS_MAPPING.key(:positive) => :positive,
      Review::STATUS_MAPPING.key(:negative) => :negative,
      Review::STATUS_MAPPING.key(:minor_review) => :minor_review,
      Review::STATUS_MAPPING.key(:major_review) => :major_review,
    }
  end

  def update
    review = Review.find(params[:id])
    if params[:email] == review.person.email
      review.update!(review_params)
      redirect_to '/'
    else
      flash[:error] = 'Podaj prawidłowy adres e-mail związany z tą recenzją!'
      redirect_to action: "edit", id: params[:id]
    end
  end

  private
  def person_params
    params.require(:person).permit(:person_id, :name,:surname,:email,:sex,roles: [])
  end

  def review_params
    params.require(:review).permit(:person_id,:status,:asked,:deadline,:remarks,:content,:article_revision_id)
  end
end
