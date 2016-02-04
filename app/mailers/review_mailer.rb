class ReviewMailer < ApplicationMailer

  def welcome_email(reveiew)
    @review = review
    mail(to: @review.person.email, subject: 'Prośba o recenzję')
  end
end
