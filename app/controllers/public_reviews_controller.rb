class PublicReviewsController < ApplicationController
  before_action -> {set_title "Recenzje"}

  def accepted_form
    @review = Review.find(params[:id])
    @review.deadline = Time.now + 2.months
    check_if_decision_possible
  end

  def rejected_form
    @review = Review.find(params[:id])
    check_if_decision_possible
  end

  def accepted
    @review = Review.find(params[:id])
    if @review.email != params[:review][:email]
      @review.errors.add(:email,"E-mail jest niepoprawny")
      flash[:error] = "Adres e-mail jest niepoprawny"
      render :accepted_form
    elsif Time.parse(params[:review][:deadline]) < Time.now
      @review.errors.add(:deadline,"Data sporządzenia recenzji jest niepoprawna")
      flash[:error] = "Data sporządzenia recenzji nie może być w przeszłości"
      render :accepted_form
    else
      @review.accept!(params[:review][:deadline])
      ReviewMailer.send_status(@review).deliver_now
    end
  end

  def rejected
    @review = Review.find(params[:id])
    if @review.email == params[:review][:email]
      @review.reject!
      ReviewMailer.send_status(@review).deliver_now
    else
      @review.errors.add(:email,"E-mail jest niepoprawny")
      flash[:error] = "Adres e-mail jest niepoprawny"
      render :rejected_form
    end
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
  def check_if_decision_possible
    if @review.asked? || @review.proposal?
      return
    else
      if @review.accepted?
        render action: "already_accepted"
      elsif @review.rejected?
        render action: "already_rejected"
      else
        render text: "Niepoprawna operacja", layout: true
      end
    end
  end

  def person_params
    params.require(:person).permit(:person_id, :name,:surname,:email,:sex,roles: [])
  end

  def review_params
    params.require(:review).permit(:person_id,:status,:asked,:deadline,:remarks,:content,:article_revision_id)
  end

end
