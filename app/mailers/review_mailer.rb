class ReviewMailer < ApplicationMailer

  def ask(review)
    @review = review
    mail(from: @review.article_revision.submission.person.email, to: @review.person.email, subject: 'Prośba o recenzję')
  end
  
  def ask_for_review(review)
    @review = review
    mail(from: @review.article_revision.submission.person.email, to: @review.person.email, subject: 'Prośba o recenzję')
  end

  def send_status(review)
    @review = review
    mail(to: @review.article_revision.submission.person.email, subject: 'Zmiana statusu recenzji')
  end
end
