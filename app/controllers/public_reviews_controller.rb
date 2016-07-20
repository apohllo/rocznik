class PublicReviewsController < ApplicationController
  before_action -> {set_title "Recenzje"}

  def accepted_form
    @review = Review.find(params[:id])
    check_if_decision_possible
  end

  def rejected_form
    @review = Review.find(params[:id])
    check_if_decision_possible
  end

  def accepted
    @review = Review.find(params[:id])
    if @review.email == params[:review][:email]
      @review.accept!
      ReviewMailer.send_status(@review).deliver_later
    else
      @review.errors.add(:email,"E-mail jest niepoprawny")
      flash[:error] = "Adres e-mail jest niepoprawny"
      render :accepted_form
    end
  end

  def rejected
    @review = Review.find(params[:id])
    if @review.email == params[:review][:email]
      @review.reject!
      ReviewMailer.send_status(@review).deliver_later
    else
      @review.errors.add(:email,"E-mail jest niepoprawny")
      flash[:error] = "Adres e-mail jest niepoprawny"
      render :rejected_form
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

end
