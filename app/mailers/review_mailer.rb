class ReviewMailer < ApplicationMailer

  def ask(review)
    @review = review
    mail(from: @review.editor_email, to: @review.reviewer_email, subject: 'Pytanie o recenzję')
  end

  def ask_for_review(review)
    @review = review
    mail(from: @review.editor_email, to: @review.reviewer_email, subject: 'Prośba o recenzję')
  end

  def send_status(review)
    @review = review
    mail(to: @review.editor_email, subject: 'Zmiana statusu recenzji')
  end

  def review_form(review)
    @review = review
    mail(to: @review.reviewer_email, from: @review.editor_email,
         subject: 'Formularz recenzyjny')
  end
end
