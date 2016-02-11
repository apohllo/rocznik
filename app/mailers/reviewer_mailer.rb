class ReviewerMailer < ApplicationMailer

  def reminder(review)
    @review = review
    mail(to: @review.person.email, subject: 'Przypomnienie o upływającym terminie recenzji')
  end
end