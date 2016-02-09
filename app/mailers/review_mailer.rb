class ReviewMailer < ApplicationMailer

  def ask(review)
    @review = review
    mail(to: @review.person.email, subject: 'Prośba o recenzję')
  end
end