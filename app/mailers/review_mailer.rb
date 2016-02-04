class ReviewMailer < ApplicationMailer

  def review_request(review)
    @review = review
    mail(to: @review.person.email, subject: 'Prośba o recenzję')
  end
end
